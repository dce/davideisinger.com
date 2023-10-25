---
title: "Get Lazy with Custom Enumerators"
date: 2015-09-28T00:00:00+00:00
draft: false
canonical_url: https://www.viget.com/articles/get-lazy-with-custom-enumerators/
---

Ruby 2.0 added the ability to create [custom
enumerators](http://ruby-doc.org/core-2.2.0/Enumerator.html#method-c-new)
and they are
[bad](https://themoviegourmet.files.wordpress.com/2010/07/machete1.jpg)
[ass](https://lifevsfilm.files.wordpress.com/2013/11/grindhouse.jpg). I
tend to group [lazy
evaluation](https://en.wikipedia.org/wiki/Lazy_evaluation) with things
like [pattern matching](https://en.wikipedia.org/wiki/Pattern_matching)
and [currying](https://en.wikipedia.org/wiki/Currying) -- super cool but
not directly applicable to our day-to-day work. I recently had the
chance to use a custom enumerator to clean up some hairy business logic,
though, and I thought I'd share.

**Some background:** our client had originally requested the ability to
select two related places to display at the bottom of a given place
detail page, one of the primary pages in our app. Over time, they found
that content editors were not always diligent about selecting these
related places, often choosing only one or none. They requested that two
related places always display, using the following logic:

1.  If the place has published, associated places, use those;
2.  Otherwise, if there are nearby places, use those;
3.  Otherwise, use the most recently updated places.

Straightforward enough. An early, naïve approach:

```ruby
def associated_places
  [
    (associated_place_1 if associated_place_1.try(:published?)),
    (associated_place_2 if associated_place_2.try(:published?)),
    *nearby_places,
    *recently_updated_places
  ].compact.first(2)
end
```

But if a place *does* have two associated places, we don't want to
perform the expensive call to `nearby_places`, and similarly, if it has
nearby places, we'd like to avoid calling `recently_updated_places`. We
also don't want to litter the method with conditional logic. This is a
perfect opportunity to build a custom enumerator:

```ruby
def associated_places
  Enumerator.new do |y|
    y << associated_place_1 if associated_place_1.try(:published?)
    y << associated_place_2 if associated_place_2.try(:published?)
    nearby_places.each { |place| y << place }
    recently_updated_places.each { |place| y << place }
  end
end
```

`Enumerator.new` takes a block with "yielder" argument. We call the
yielder's `yield` method[^1],
aliased as `<<`, to return the next enumerable value. Now, we can just
say `@place.associated_places.take(2)` and we'll always get back two
places with minimum effort.

This code ticks all the boxes: fast, clean, and nerdy as hell. If you're
interested in learning more about Ruby's lazy enumerators, I recommend
[*Ruby 2.0 Works Hard So You Can Be
Lazy*](http://patshaughnessy.net/2013/4/3/ruby-2-0-works-hard-so-you-can-be-lazy)
by Pat Shaughnessy and [*Lazy
Refactoring*](https://robots.thoughtbot.com/lazy-refactoring) on the
Thoughtbot blog.

[^1]: Confusing name -- not the same as the `yield` keyword.
