---
title: "Encrypt and Dither Photos in Hugo"
date: 2024-02-05T09:47:45-05:00
draft: true
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

Intro text here ...

<!--more-->

* https://github.com/gohugoio/hugo/issues/8598

A more ambitions version of me would take a crack at adding this functionality to Hugo and opening a PR.

```sh
openssl rand -hex -out secret.key 32
```

---

```sh
openssl \
  aes-256-cbc \
  -in secretfile.txt \
  -out secretfile.txt.enc \
  -pass file:secret.key \
  -iter 1000000
```

---

```ruby
Dir.glob("content/**/*.{jpg,jpeg,png}").each do |path|
  `openssl aes-256-cbc -in #{path} -out #{path}.enc -pass file:secret.key -iter 1000000`
end
```

* https://gohugo.io/content-management/image-processing/#remote-resource

## Deleting images out of Git history

* https://stackoverflow.com/a/64563565
* https://github.com/newren/git-filter-repo
* https://formulae.brew.sh/formula/git-filter-repo

```ruby
Dir.glob("content/**/*.{jpg,jpeg,png}") do |path|
  `git filter-repo --invert-paths --force --path #{path}`
end
```

***

I'm 41 years old, and this stuff still gives me a buzz like it did when I was 14.
