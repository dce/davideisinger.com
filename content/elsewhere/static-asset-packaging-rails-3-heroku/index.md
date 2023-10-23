---
title: "Static Asset Packaging for Rails 3 on Heroku"
date: 2011-03-29T00:00:00+00:00
draft: false
needs_review: true
canonical_url: https://www.viget.com/articles/static-asset-packaging-rails-3-heroku/
---

**Short Version:** the easiest way to combine and minify static assets
(CSS and Javascript) in your Rails 3 app running on Heroku is to use
[AssetPackager](https://github.com/sbecker/asset_packager) with [this
fork of Heroku Asset
Packager](https://github.com/cbeier/heroku_asset_packager). It just
works.

**Long version:** in his modern day classic, [High Performance Web
Sites](https://www.amazon.com/High-Performance-Web-Sites-Essential/dp/0596529309),
Steve Souders\' very first rule is to "make fewer HTTP requests." In
practical terms, among other things, this means to combine separate CSS
and Javascript files whenever possible. The creators of the Rails
framework took this advice to heart, adding the `:cache => true` option
to the
[`javascript_include_tag`](http://apidock.com/rails/ActionView/Helpers/AssetTagHelper/javascript_include_tag)
and
[`stylesheet_link_tag`](http://apidock.com/rails/ActionView/Helpers/AssetTagHelper/stylesheet_link_tag)
helpers to provide asset concatenation at no cost to the developer.

As time went on, our needs outgrew the capabilities of `:cache => true`
and solutions like
[AssetPackager](https://github.com/sbecker/asset_packager) came onto the
scene, offering increased control over how assets are combined as well
as *minification*, stripping comments and unnecessary whitespace from
CSS and Javascript files before packaging them together. Later, even
more sophisticated solutions like
[Jammit](https://documentcloud.github.com/jammit/) arrived, offering
even more minification capabilities including inlining small images into
CSS.

Of course, static asset packaging wasn't the only part of the Rails
ecosystem that was undergoing major changes during this time. An
increased emphasis on ease of deployment saw the rise of
[Capistrano](https://github.com/capistrano/capistrano/wiki),
[Passenger](http://www.modrails.com/), and eventually
[Heroku](https://heroku.com/), which offers hands-free system
maintenance and simple `git push heroku` deployment. This simplification
is not without trade-offs, though; you can only write to your app's
`tmp` directory and the lack of root access means that you can't install
additional software. Both of these limitations have ramifications for
static asset packaging, namely:

1.  Both `:cache => true` and standard AssetPackager work by writing
    files into your app's `public` directory, which, as you can likely
    guess, is *verboten*.

2.  Jammit has several compression options, but all of them require Java
    support, which we don't have on Heroku. You have the option of
    compressing your assets and checking them into your repository by
    hand, but I for one can't stand putting build artifacts in the repo.

I've seen a lot of questions about how to do static asset packaging on
Heroku and just as many bad answers (which I'll avoid linking to here).
The best solution we've found uses
[AssetPackager](https://github.com/sbecker/asset_packager) along with
[this fork of Heroku Asset
Packager](https://github.com/cbeier/heroku_asset_packager) that has been
modified to work with Rails 3. It's not the sexiest solution, but it
works, and you'll never have to think about it again.
