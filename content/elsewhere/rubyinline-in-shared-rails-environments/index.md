---
title: "RubyInline in Shared Rails Environments"
date: 2008-05-23T00:00:00+00:00
draft: false
canonical_url: https://www.viget.com/articles/rubyinline-in-shared-rails-environments/
---

As an end-to-end web production company, we have a vested interest in
making Rails applications easier to deploy for both development and
production purposes. We've developed
[Tyrant](http://trac.extendviget.com/tyrant/wiki), a Rails app for
running Rails apps, and we're [eagerly
watching](https://www.viget.com/extend/passenger-let-it-ride/) as new
solutions are created and refined.

But it's a new market, and current solutions are not without their share
of obstacles. In working with both Tyrant and [Phusion
Passenger](http://www.modrails.com/), we've encountered difficulties
running applications that use
[RubyInline](http://www.zenspider.com/ZSS/Products/RubyInline/) to embed
C into Ruby code (e.g.,
[ImageScience](http://seattlerb.rubyforge.org/image_science/classes/ImageScience.html),
my image processing library of choice). Try to start up an app that uses
RubyInline code in a shared environment, and you might encounter the
following error:

```
/Library/Ruby/Gems/1.8/gems/RubyInline-3.6.7/lib/inline.rb:325:in `mkdir': Permission denied - /home/users/www-data/.ruby_inline (Errno::EACCES)
```

RubyInline uses the home directory of the user who started the server to
compile the inline code; problems occur when the current process is
owned by a different user. "Simple," you think. "I'll just open that
directory up to everybody." Not so fast, hotshot. Try to start the app
again, and you get the following:

```
/home/users/www-data/.ruby_inline is insecure (40777). It may not be group or world writable. Exiting.
```

Curses! Fortunately, VigetExtend is here to help. Drop this into your
environment-specific config file:

```ruby
temp = Tempfile.new('ruby_inline', '/tmp')
dir = temp.path
temp.delete
Dir.mkdir(dir, 0755)
ENV['INLINEDIR'] = dir
```

We use the [Tempfile](http://ruby-doc.org/core/classes/Tempfile.html)
library to generate a guaranteed-unique filename in the `/tmp`
directory, prepended with "ruby_inline." After storing the filename, we
delete the tempfile and create a directory with the proper permissions
in its place. We then store the directory path in the `INLINEDIR`
environment variable, so that RubyInline knows to use it to compile.
