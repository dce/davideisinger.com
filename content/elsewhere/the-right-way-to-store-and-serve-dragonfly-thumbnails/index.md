---
title: "The Right Way to Store and Serve Dragonfly Thumbnails"
date: 2018-06-29T00:00:00+00:00
draft: false
canonical_url: https://www.viget.com/articles/the-right-way-to-store-and-serve-dragonfly-thumbnails/
---

We love and use [Dragonfly](https://github.com/markevans/dragonfly) to
manage file uploads in our Rails applications. Specifically, its API for
generating thumbnails is a huge improvement over its predecessors. There
is one area where the library falls short, though: out of the box,
Dragonfly doesn't do anything to cache the result of a resize/crop,
meaning a naïve implementation would rerun these operations every time
we wanted to show a thumbnailed image to a user.

[The Dragonfly documentation offers some
suggestion](https://markevans.github.io/dragonfly/cache#processing-on-the-fly-and-serving-remotely)
about how to handle this issue, but makes it clear that you're pretty
much on your own:

```ruby
Dragonfly.app.configure do

  # Override the .url method...
  define_url do |app, job, opts|
    thumb = Thumb.find_by_signature(job.signature)
    # If (fetch 'some_uid' then resize to '40x40') has been stored already, give the datastore's remote url ...
    if thumb
      app.datastore.url_for(thumb.uid)
    # ...otherwise give the local Dragonfly server url
    else
      app.server.url_for(job)
    end
  end

  # Before serving from the local Dragonfly server...
  before_serve do |job, env|
    # ...store the thumbnail in the datastore...
    uid = job.store

    # ...keep track of its uid so next time we can serve directly from the datastore
    Thumb.create!(uid: uid, signature: job.signature)
  end

end
```

To summarize: create a `Thumb` model to track uploaded crops. The
`define_url` callback executes when you ask for the URL for a thumbnail,
checking if a record exists in the database with a matching signature
and, if so, returning the URL to the stored image (e.g. on S3). The
`before_serve` block defines what happens when Dragonfly receives a
request for a thumbnailed image (the ones that look like `/media/...`),
storing the thumbnail and then creating a corresponding record in the
database.

The problem with this approach is that if someone gets ahold of the
initial `/media/...` URL, they can cause your app to reprocess the same
image multiple times, or store multiple copies of the same image, or
just fail outright. Here's how we can do it better.

First, create the `Thumbs` table, and put unique indexes on both
columns. This ensures we'll never store multiple versions of the same
cropping of any given image.

```ruby
class CreateThumbs < ActiveRecord::Migration[5.2]
  def change
    create_table :thumbs do |t|
      t.string :signature, null: false
      t.string :uid, null: false

      t.timestamps
    end

    add_index :thumbs, :signature, unique: true
    add_index :thumbs, :uid, unique: true
  end
end
```

Then, create the model. Same idea: ensure uniqueness of signature and
UID.

```ruby
class Thumb < ApplicationRecord
  validates :signature,
            :uid,
            presence: true,
            uniqueness: true
end
```

Then replace the `before_serve` block from above with the following:

```ruby
before_serve do |job, env|
  thumb = Thumb.find_by_signature(job.signature)

  if thumb
    throw :halt,
      [301, { "Location" => job.app.remote_url_for(thumb.uid) }, [""]]
  else
    uid = job.store
    Thumb.create!(uid: uid, signature: job.signature)
  end
end
```

*([Here's the full resulting
config.](https://gist.github.com/dce/4e79183a105e415ca0e5e1f1709089b8))*

The key difference here is that, before manipulating, storing, and
serving an image, we check if we already have a thumbnail with the
matching signature. If we do, we take advantage of a [cool
feature](http://markevans.github.io/dragonfly/v0.9.15/file.URLs.html#Overriding_responses)
of Dragonfly (and of Ruby) and `throw`[^1] a Rack response that redirects
to the existing asset which Dragonfly
[catches](https://github.com/markevans/dragonfly/blob/a6835d2a9a1195df840c643d6f24df88b1981c91/lib/dragonfly/server.rb#L55)
and returns to the user.

------------------------------------------------------------------------

So that's that: a bare minimum approach to storing and serving your
Dragonfly thumbnails without the risk of duplicates. Your app's needs
may vary slightly, but I think this serves as a better default than what
the docs recommend. Let me know if you have any suggestions for
improvement in the comments below.

*Dragonfly illustration courtesy of
[Vecteezy](https://www.vecteezy.com/vector-art/165467-free-insect-line-icon-vector).*

[^1]:  For more information on Ruby's `throw`/`catch` mechanism, [here is
a good explanation from *Programming
Ruby*](http://phrogz.net/ProgrammingRuby/tut_exceptions.html#catchandthrow)
or see chapter 4.7 of Avdi Grimm's [*Confident
Ruby*](https://pragprog.com/book/agcr/confident-ruby).
