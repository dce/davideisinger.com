---
title: "Five Turbo Lessons I Learned the Hard Way"
date: 2021-08-02T00:00:00+00:00
draft: false
canonical_url: https://www.viget.com/articles/five-turbo-lessons-i-learned-the-hard-way/
---

We've been using [Turbo](https://turbo.hotwired.dev/) on our latest
client project (a Ruby on Rails web application), and after a slight
learning curve, we've been super impressed by how much dynamic behavior
it's allowed us to add while writing very little code. We have hit some
gotchas (or at least some undocumented behavior), often with solutions
that lie deep in GitHub issue threads. Here are a few of the things
we've discovered along our Turbo journey.

### Turbo Stream fragments are server responses (and you don't have to write them by hand)

[The docs on Turbo Streams](https://turbo.hotwired.dev/handbook/streams)
kind of bury the lede. They start out with the markup to update the
client, and only [further
down](https://turbo.hotwired.dev/handbook/streams#streaming-from-http-responses)
illustrate how to use them in a Rails app. Here's the thing: you don't
really need to write any stream markup at all. It's (IMHO) cleaner to
just use the built-in Rails methods, i.e.

```ruby
render turbo_stream: turbo_stream.update("flash", partial: "shared/flash")
````

And though [DHH would
disagree](https://github.com/hotwired/turbo-rails/issues/77#issuecomment-757349251),
you can use an array to make multiple updates to the page.

### Send `:unprocessable_entity` to re-render a form with errors

For create/update actions, we follow the usual pattern of redirect on
success, re-render the form on error. Once you enable Turbo, however,
that direct rendering stops working. The solution is to [return a 422
status](https://github.com/hotwired/turbo-rails/issues/12), though we
prefer the `:unprocessable_entity` alias (so like
`render :new, status: :unprocessable_entity`). This seems to work well
with and without JavaScript and inside or outside of a Turbo frame.

### Use `data-turbo="false"` to break out of a frame

If you have a link inside of a frame that you want to bypass the default
Turbo behavior and trigger a full page reload, [include the
`data-turbo="false"`
attribute](https://github.com/hotwired/turbo/issues/45#issuecomment-753444256)
(or use `data: { turbo: false }` in your helper).

*Update from good guy [Leo](https://www.viget.com/about/team/lbauza/):
you can also use
[`target="_top"`](https://turbo.hotwired.dev/handbook/frames#targeting-navigation-into-or-out-of-a-frame)
to load all the content from the response without doing a full page
reload, which seems (to me, David) what you typically want except under
specific circumstances.*

### Use `requestSubmit()` to trigger a Turbo form submission via JavaScript

If you have some JavaScript (say in a Stimulus controller) that you want
to trigger a form submission with a Turbo response, you can't use the
usual `submit()` method. [This discussion
thread](https://discuss.hotwired.dev/t/triggering-turbo-frame-with-js/1622/15)
sums it up well:

> It turns out that the turbo-stream mechanism listens for form
> submission events, and for some reason the submit() function does not
> emit a form submission event. That means that it'll bring back a
> normal HTML response. That said, it looks like there's another method,
> requestSubmit() which does issue a submit event. Weird stuff from
> JavaScript land.

So, yeah, use `requestSubmit()` (i.e. `this.formTarget.requestSubmit()`)
and you're golden (except in Safari, where you might need [this
polyfill](https://github.com/javan/form-request-submit-polyfill)).

### Loading the same URL multiple times in a Turbo Frame

I hit an interesting issue with a form inside a frame: in a listing of
comments, I set it up where you could click an edit link, and the
content would be swapped out for an edit form using a Turbo Frame.
Update and save your comment, and the new content would render. Issue
was, if you hit the edit link *again*, nothing would happen. Turns out,
a Turbo frame won't reload a URL if it thinks it already has the
contents of that URL (which it tracks in a `src` attribute).

The [solution I
found](https://github.com/hotwired/turbo/issues/245#issuecomment-847711320)
was to append a timestamp to the URL to ensure it's always unique.
Works like a charm.

*Update from good guy
[Joshua](https://www.viget.com/about/team/jpease/): this has been fixed
an a [recent
update](https://github.com/hotwired/turbo/releases/tag/v7.0.0-beta.7).*

---

These small issues aside, Turbo has been a BLAST to work with and has
allowed us to easily build a highly dynamic app that works surprisingly
well even with JavaScript disabled. We're excited to see how this
technology develops.
