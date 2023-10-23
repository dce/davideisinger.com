---
title: "Large Images in Rails"
date: 2012-09-18T00:00:00+00:00
draft: false
needs_review: true
canonical_url: https://www.viget.com/articles/large-images-in-rails/
---

The most visually striking feature on the new
[WWF](http://worldwildlife.org/) site, as well as the source of the
largest technical challenges, is the photography. The client team is
working with gorgeous, high-fidelity photographs loaded with metadata,
and it was up to us to make them work in a web context. Here are a few
things we did to make the site look and perform like a veritable [snow
leopard](http://worldwildlife.org/species/snow-leopard).

## Optimize Images

The average uploaded photo into this system is around five megabytes, so
the first order of business was to find ways to get filesize down. Two
techniques turned out to be very effective:
[jpegtran](http://jpegclub.org/jpegtran/) and
[ImageMagick](http://www.imagemagick.org/script/index.php)'s `quality`
option. We run all photos through a custom
[Paperclip](https://github.com/thoughtbot/paperclip) processor that
calls out to jpegtran to losslessly optimize image compression and strip
out metadata. In some cases, we were seeing thumbnailed images go from
60k to 15k by removing unused color profile data. We save the resulting
images out at 75% quality with the following Paperclip directive:

    has_attached_file :image,
     :convert_options => { :all => "-quality 75" },
     :styles => { # ...

Enabling this option has a huge impact on filesize (about a 90%
reduction) with no visible loss of quality. Be aware that we're working
with giant, unoptimized images; if you're going to be uploading images
that have already been saved out for the web, this level of compression
is probably too aggressive.

## Process in Background

Basic maths: large images × lots of crop styles = long processing time.
As the site grew, the delay after uploading a new photo increased until
it became unacceptable. It was time to implement background processing.
[Resque](https://github.com/defunkt/resque) and
[delayed_paperclip](https://github.com/jstorimer/delayed_paperclip) to
the ... rescue (derp). These two gems make it super simple to process
images outside of the request/response flow with a simple
`process_in_background :image` in your model.

A few notes: as of this writing, delayed_paperclip hasn't been updated
recently. [Here's a fork that
works](https://github.com/tommeier/delayed_paperclip) from tommeier. I
recommend using the
[rescue-ensure-connected](https://github.com/socialcast/resque-ensure-connected)
gem if you're going to run Resque in production to keep your
long-running processes from losing their DB connnections.

## Server Configuration

You'll want to put [far-future expires
headers](http://developer.yahoo.com/performance/rules.html#expires) on
these photos so that browsers know not to redownload them. If you
control the servers from which they'll be served, you can configure
Apache to send these headers with the following bit of configuration:

    ExpiresActive On
    ExpiresByType image/png "access plus 1 year"
    ExpiresByType image/gif "access plus 1 year"
    ExpiresByType image/jpeg "access plus 1 year"

([Similarly, for
nginx](http://www.agileweboperations.com/far-future-expires-headers-for-ruby-on-rails-with-nginx).)
When working with a bunch of large files, though, you're probably better
served by uploading them to S3 or RackSpace Cloud Files and serving them
from there.

------------------------------------------------------------------------

Another option to look at might be
[Dragonfly](https://github.com/markevans/dragonfly), which takes a
different approach to photo processing than does Paperclip, resizing on
the fly rather than on upload. This might obviate the need for Resque
but at unknown (by me) cost. We hope that some of this will be helpful
in your next photo-intensive project.
