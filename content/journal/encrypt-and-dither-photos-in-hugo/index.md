---
title: "Encrypt and Dither Photos in Hugo"
date: 2024-02-05T09:47:45-05:00
draft: false
references:
- title: "Elliot Jay Stocks  | 2023 in review"
  url: https://elliotjaystocks.com/blog/2023-in-review
  date: 2024-02-02T15:51:48Z
  file: elliotjaystocks-com-fcit8u.txt
- title: "Encrypt and decrypt a file using SSH keys"
  url: https://www.bjornjohansen.com/encrypt-file-using-ssh-key
  date: 2024-02-05T14:50:24Z
  file: www-bjornjohansen-com-hqud3x.txt
- title: "Ditherpunk — The article I wish I had about monochrome image dithering — surma.dev"
  url: https://surma.dev/things/ditherpunk/
  date: 2024-02-05T14:50:25Z
  file: surma-dev-e4sfuv.txt
- title: "About the Solar Powered Website | LOW←TECH MAGAZINE"
  url: https://solar.lowtechmagazine.com/about/the-solar-website/
  date: 2024-02-05T14:50:28Z
  file: solar-lowtechmagazine-com-vj7kk5.txt
---

I encrypted all the photos on this site and wrote a tiny image server that decrypts and dithers the photos, then created a Hugo shortcode to display dithered images in posts. It keeps high-res photos of my kid off the web, and it looks cool.

<!--more-->

***

When I was first setting up this site, I considered giving all the photos a monochrome [dithered][1] treatment à la [Low-tech Magazine][2]. Hugo has impressive [image manipulation functionality][3] but doesn't include dithering and [seems unlikely to add it][4]. I opted for full-color photos and went on with my life.

[1]: https://surma.dev/things/ditherpunk/
[2]: https://solar.lowtechmagazine.com/
[3]: https://gohugo.io/content-management/image-processing/
[4]: https://github.com/gohugoio/hugo/issues/8598

Most of what I post on this site are these monthly [dispatches][5] that start with what my family's been up to in the last month and include several high-resolution photos. Last week, I was reading Elliot Jay Stocks' "[2023 in review][6]," and he's adament about not posting photos of his kids. That inspired me to take another crack at getting dithered images working -- I take a lot of joy out of documenting our family life, and low-res, dithered images seemed like a good balance between giant full-color photos and not showing people in photos at all. And to add another wrinkle: this site is [open source][7], so I also needed to ensure that the source images wouldn't be available on GitHub.

[5]: /tags/dispatch/
[6]: https://elliotjaystocks.com/blog/2023-in-review
[7]: https://github.com/dce/davideisinger.com

I tried treating the full-size images with ImageMagick on the command line and then letting Hugo resize the result, but I wasn't happy with the output -- there's still way too much data in a dithered 3000x2000px image, so when you scale it down, it just looks like a crappy black-and-white photo. Furthermore, the encoding wasn't properly optimizing for two-color images and so the files were larger than I wanted.

I needed to find some way to scale the images to the appropriate size and _then_ apply the dither.  Fortunately, Hugo has the ability to [fetch remote images][8], which got me thinking about a separate image processing service. After a late night of coding, I've got a solution I'm quite pleased with. Read on for more details.

[8]: https://gohugo.io/content-management/image-processing/#remote-resource

### 1. Encrypt all images

We'll use OpenSSL to encrypt our images. I used [this guide][9] to get started. First, generate a secret key (the `-hex` option gives us something we can paste into a GitHub secret later):

[9]: https://github.com/dce/davideisinger.com/blob/7285c58add56e2ac6b5f7bf62914f0615ac23c9f/.github/workflows/deploy.yml

```sh
openssl rand -hex -out secret.key 32
```

Don't forget to `gitignore` the key:

```sh
echo secret.key >> .gitignore
```

Then use it to encrypt all the images in the `content` folder (I use an interactive Ruby shell for this sort of thing because I'm not very good at shell scripting):

```ruby
Dir.glob("content/**/*.{jpg,jpeg,png}").each do |path|
  %x(
    openssl \
      aes-256-cbc \
      -in #{path} \
      -out #{path}.enc \
      -pass file:secret.key \
      -iter 1000000
    )
end
```

### 2. Build a tiny image server

I wrote a [very simple image server][10] using [Sinatra][11] and [MiniMagick][12] that takes a path to an image and an optional geometry string and returns a dithered image. I won't paste the entire file here but it's really pretty short and simple.

[10]: https://github.com/dce/davideisinger.com/blob/bf5238dd56b6dfe9ee2f1d629d017b2075750663/bin/dither/dither.rb
[11]: https://sinatrarb.com/
[12]: https://github.com/minimagick/minimagick

Run it like this:

```sh
cd bin/dither && \
  bundle install && \
  ROOT=[SITE_ROOT]/content \
  KEY=[SITE_ROOT]/secret.key \
  bundle exec ruby dither.rb
````

Then you should be able to visit <http://localhost:4567/path/to/file.jpg?geo=400x300> in your browser (assuming you have an encrypted image at `content/path/to/file.jpg.enc`) to see it working.

### 3. Create a Hugo shortcode to fetch dithered images

We need to tell Hugo where to find our dither server. Give Hugo access to the `DITHER_SERVER` environment variable in `config.toml`:

```toml
[security]
  [security.funcs]
    getenv = ['DITHER_SERVER']
```

Then start Hugo like this:

```sh
DITHER_SERVER=http://localhost:4567 hugo server
```

Now we'll create the shortcode ([`layouts/shortcodes/dither.html`][13]):

```html
{{ $file := printf "%s%s" .Page.File.Dir (.Get 0) }}
{{ $geo := .Get 1 }}
{{ $img := resources.GetRemote (printf "%s/%s?geo=%s" (getenv "DITHER_SERVER") $file $geo) }}
{{ $imgClass := .Get 2 }}

<a href="{{ $img.RelPermalink }}">
  <img src="{{ $img.RelPermalink }}"
    width="{{ $img.Width }}"
    height="{{ $img.Height }}"
    class="{{ $imgClass }}"
  >
  {{ with .Inner }}
    <figcaption>
      {{ . }}
    </figcaption>
  {{ end }}
</a>
```

Adjust for your needs, but the gist is:

1. Construct a URL from `DITHER_SERVER`, the directory that the page lives in, the supplied file name, and the (optional) geometry string
2. Use `resources.GetRemote` to fetch the image
3. Display as appropriate

[13]: https://github.com/dce/davideisinger.com/blob/2cda4b8f4e98bb9df84747da283d13075aac4d41/themes/v2/layouts/shortcodes/dither.html

Use it like this:

```
{{</*dither IMG_2374.jpeg "782x1200" /*/>}}
```

### 4. Delete the unencrypted images from the repository

Now that everything's working, let's remove all the uncrypted images from the repository. It's not enough to just `git rm` them, since they'd still be present in the git history, so we'll use [`git filter-repo`][14] to rewrite the history as if they never existed.

```ruby
Dir.glob("content/**/*.{jpg,jpeg,png}") do |path|
  `git filter-repo --invert-paths --force --path #{path}`
end
```

[14]: https://github.com/newren/git-filter-repo

### 5. Tweak site styles

The resulting images will be entirely black and white. If your site, like mine, doesn't use a perfectly white background, you can improve the display of the dithered images by setting `mix-blend-mode` to `multiply`:

```css
img {
  mix-blend-mode: multiply;
}
```

The blacks will still show as black, but the whites will now be the background color of your site.

### 6. Update the deploy workflow

This site uses GitHub Actions to deploy on pushes to the `main` branch, and we need to make a few updates to our workflow to generate the static site with dithered images:

* Add the secret key as an Actions Secret
* Add workflow steps to
  * Install Ruby and the required Gem dependencies
  * Write the secret key to a file
  * Start the dither server as a background task (i.e. with `&`)
* Add the `DITHER_SERVER` environment variable so that Hugo knows where to find it

[Here's the deploy workflow for this site][15] for reference.

[15]: https://github.com/dce/davideisinger.com/blob/7285c58add56e2ac6b5f7bf62914f0615ac23c9f/.github/workflows/deploy.yml

***

I'm 41 years old, and this stuff still gives me a buzz like it did when I was 14.
