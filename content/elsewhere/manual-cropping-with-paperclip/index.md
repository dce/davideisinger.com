---
title: "Manual Cropping with Paperclip"
date: 2012-05-31T00:00:00+00:00
draft: false
needs_review: true
canonical_url: https://www.viget.com/articles/manual-cropping-with-paperclip/
---

It's relatively straightforward to add basic manual (browser-based)
cropping support to your
[Paperclip](https://github.com/thoughtbot/paperclip) image attachments.
See [RJCrop](https://github.com/jschwindt/rjcrop) for one valid
approach. What's not so straightforward, though, is adding manual
cropping while preserving Paperclip's built-in thumbnailing
capabilities. Here's how.

Just so we're on the same page, when we're talking about "thumbnailing,"
we're talking about the ability to set a size of `50x50#`, which means
"scale and crop the image into a 50 by 50 pixel square." If the original
image is 200x100, it would first be scaled down to 100x50, and then 25
pixels trimmed from both sides to arrive at the final dimensions. This
is not a native capability of ImageMagick, but rather the result of some
decently complex code in Paperclip.

Our goal is to allow a user to select a portion of an image and then
create a thumbnail of *just that selected portion*, ideally taking
advantage of Paperclip\'s existing cropping/scaling logic.

Any time you're dealing with custom Paperclip image processing, you're
talking about creating a custom
[Processor](https://github.com/thoughtbot/paperclip#post-processing). In
this case, we'll be subclassing the default
[Thumbnail](https://github.com/thoughtbot/paperclip/blob/master/lib/paperclip/thumbnail.rb)
processor and making a few small tweaks. We'll imagine you have a model
with the fields `crop_x`, `crop_y`, `crop_width`, and `crop_height`. How
those get set is left as an exercise for the reader (though I recommend
[JCrop](http://deepliquid.com/content/Jcrop.html)). Some code, then:

    module Paperclip
     class ManualCropper < Thumbnail
     def initialize(file, options = {}, attachment = nil)
     super
     @current_geometry.width = target.crop_width
     @current_geometry.height = target.crop_height
     end

     def target
     @attachment.instance
     end

     def transformation_command
     crop_command = [
     "-crop",
     "#{target.crop_width}x" 
     "#{target.crop_height}+" 
     "#{target.crop_x}+" 
     "#{target.crop_y}",
     "+repage"
     ]

     crop_command + super
     end
     end
    end

In our `initialize` method, we call super, which sets a whole host of
instance variables, include `@current_geometry`, which is responsible
for creating the geometry string that will crop and scale our image. We
then set its `width` and `height` to be the dimensions of our cropped
image.

We also override the `transformation_command` method, prepending our
manual crop to the instructions provided by `@current_geometry`. The end
result is a geometry string which crops the image, repages it, then
scales the image and crops it a second time. Simple, but not certainly
not intuitive, at least not to me.

From here, you can include this cropper using the `:processers`
directive in your `has_attached_file` declaration, and you should be
good to go. This simple approach assumes that the crop dimensions will
always be set, so tweak accordingly if that's not the case.
