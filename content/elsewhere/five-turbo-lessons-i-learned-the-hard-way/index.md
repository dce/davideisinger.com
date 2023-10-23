---
title: "Five Turbo Lessons I Learned the Hard Way"
date: 2021-08-02T00:00:00+00:00
draft: false
needs_review: true
canonical_url: https://www.viget.com/articles/five-turbo-lessons-i-learned-the-hard-way/
---

We\'ve been using [Turbo](https://turbo.hotwired.dev/) on our latest
client project (a Ruby on Rails web application), and after a slight
learning curve, we\'ve been super impressed by how much dynamic behavior
it\'s allowed us to add while writing very little code. We have hit some
gotchas (or at least some undocumented behavior), often with solutions
that lie deep in GitHub issue threads. Here are a few of the things
we\'ve discovered along our Turbo journey.

[]{#turbo-stream-fragments-are-server-responses}

### Turbo Stream fragments are server responses (and you don\'t have to write them by hand) [\#](#turbo-stream-fragments-are-server-responses "Direct link to Turbo Stream fragments are server responses (and you don't have to write them by hand)"){.anchor aria-label="Direct link to Turbo Stream fragments are server responses (and you don't have to write them by hand)"}

[The docs on Turbo Streams](https://turbo.hotwired.dev/handbook/streams)
kind of bury the lede. They start out with the markup to update the
client, and only [further
down](https://turbo.hotwired.dev/handbook/streams#streaming-from-http-responses)
illustrate how to use them in a Rails app. Here\'s the thing: you don\'t
really need to write any stream markup at all. It\'s (IMHO) cleaner to
just use the built-in Rails methods, i.e.

    render turbo_stream: turbo_stream.update("flash", partial: "shared/flash")

And though [DHH would
disagree](https://github.com/hotwired/turbo-rails/issues/77#issuecomment-757349251),
you can use an array to make multiple updates to the page.

[]{#send-unprocessable-entity-to-re-render-a-form-with-errors}

### Send `:unprocessable_entity` to re-render a form with errors [\#](#send-unprocessable-entity-to-re-render-a-form-with-errors "Direct link to Send :unprocessable_entity to re-render a form with errors"){.anchor aria-label="Direct link to Send :unprocessable_entity to re-render a form with errors"}

For create/update actions, we follow the usual pattern of redirect on
success, re-render the form on error. Once you enable Turbo, however,
that direct rendering stops working. The solution is to [return a 422
status](https://github.com/hotwired/turbo-rails/issues/12), though we
prefer the `:unprocessable_entity` alias (so like
`render :new, status: :unprocessable_entity`). This seems to work well
with and without JavaScript and inside or outside of a Turbo frame.

[]{#use-data-turbo-false-to-break-out-of-a-frame}

### Use `data-turbo="false"` to break out of a frame [\#](#use-data-turbo-false-to-break-out-of-a-frame "Direct link to Use data-turbo="false" to break out of a frame"){.anchor aria-label="Direct link to Use data-turbo=\"false\" to break out of a frame"}

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

[]{#use-requestSubmit-to-trigger-a-turbo-form-submission-via-javaScript}

### Use `requestSubmit()` to trigger a Turbo form submission via JavaScript [\#](#use-requestSubmit-to-trigger-a-turbo-form-submission-via-javaScript "Direct link to Use requestSubmit() to trigger a Turbo form submission via JavaScript"){.anchor aria-label="Direct link to Use requestSubmit() to trigger a Turbo form submission via JavaScript"}

If you have some JavaScript (say in a Stimulus controller) that you want
to trigger a form submission with a Turbo response, you can\'t use the
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
and you\'re golden (except in Safari, where you might need [this
polyfill](https://github.com/javan/form-request-submit-polyfill)).

[]{#loading-the-same-url-multiple-times-in-a-turbo-frame}

### Loading the same URL multiple times in a Turbo Frame [\#](#loading-the-same-url-multiple-times-in-a-turbo-frame "Direct link to Loading the same URL multiple times in a Turbo Frame"){.anchor aria-label="Direct link to Loading the same URL multiple times in a Turbo Frame"}

I hit an interesting issue with a form inside a frame: in a listing of
comments, I set it up where you could click an edit link, and the
content would be swapped out for an edit form using a Turbo Frame.
Update and save your comment, and the new content would render. Issue
was, if you hit the edit link *again*, nothing would happen. Turns out,
a Turbo frame won't reload a URL if it thinks it already has the
contents of that URL (which it tracks in a `src` attribute).

The [solution I
found](https://github.com/hotwired/turbo/issues/245#issuecomment-847711320)
was to append a timestamp to the URL to ensure it\'s always unique.
Works like a charm.

*Update from good guy
[Joshua](https://www.viget.com/about/team/jpease/): this has been fixed
an a [recent
update](https://github.com/hotwired/turbo/releases/tag/v7.0.0-beta.7).*


[[Learn More]{.util-breadcrumb-md .mb-8 .group-hover:translate-y-20
.group-hover:opacity-0 .transition-all .ease-in-out
.duration-500}](https://www.viget.com/careers/application-developer/){.relative
.flex .group .flex-col .p-32 .md:p-40 .lg:p-64 .z-10}

### We're hiring Application Developers. Learn more and introduce yourself. {#were-hiring-application-developers.-learn-more-and-introduce-yourself. .text-20 .md:text-24 .lg:text-32 .font-bold .leading-[170%] .group-hover:-translate-y-20 .transition-transform .ease-in-out .duration-500}

![](data:image/svg+xml;base64,PHN2ZyBjbGFzcz0icmVjdC1pY29uLW1kIHNlbGYtZW5kIG10LTE2IGdyb3VwLWhvdmVyOi10cmFuc2xhdGUteS0yMCB0cmFuc2l0aW9uLWFsbCBlYXNlLWluLW91dCBkdXJhdGlvbi01MDAiIHZpZXdib3g9IjAgMCAyNCAyNCIgZmlsbD0ibm9uZSIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIiBhcmlhLWhpZGRlbj0idHJ1ZSI+CjxwYXRoIGZpbGwtcnVsZT0iZXZlbm9kZCIgY2xpcC1ydWxlPSJldmVub2RkIiBkPSJNMTMuNzg0OCAxOS4zMDkxQzEzLjQ3NTggMTkuNTg1IDEzLjAwMTcgMTkuNTU4MyAxMi43MjU4IDE5LjI0OTRDMTIuNDQ5OCAxOC45NDA1IDEyLjQ3NjYgMTguNDY2MyAxMi43ODU1IDE4LjE5MDRMMTguNzg2NiAxMi44MzAxTDQuNzUxOTUgMTIuODMwMUM0LjMzNzc0IDEyLjgzMDEgNC4wMDE5NSAxMi40OTQzIDQuMDAxOTUgMTIuMDgwMUM0LjAwMTk1IDExLjY2NTkgNC4zMzc3NCAxMS4zMzAxIDQuNzUxOTUgMTEuMzMwMUwxOC43ODU1IDExLjMzMDFMMTIuNzg1NSA1Ljk3MDgyQzEyLjQ3NjYgNS42OTQ4OCAxMi40NDk4IDUuMjIwNzYgMTIuNzI1OCA0LjkxMTg0QzEzLjAwMTcgNC42MDI5MiAxMy40NzU4IDQuNTc2MTggMTMuNzg0OCA0Ljg1MjEyTDIxLjIzNTggMTEuNTA3NkMyMS4zNzM4IDExLjYyNDQgMjEuNDY5IDExLjc5MDMgMjEuNDk0NSAxMS45NzgyQzIxLjQ5OTIgMTIuMDExOSAyMS41MDE1IDEyLjA0NjEgMjEuNTAxNSAxMi4wODA2QzIxLjUwMTUgMTIuMjk0MiAyMS40MTA1IDEyLjQ5NzcgMjEuMjUxMSAxMi42NEwxMy43ODQ4IDE5LjMwOTFaIj48L3BhdGg+Cjwvc3ZnPg==){.rect-icon-md
.self-end .mt-16 .group-hover:-translate-y-20 .transition-all
.ease-in-out .duration-500}

These small issues aside, Turbo has been a BLAST to work with and has
allowed us to easily build a highly dynamic app that works surprisingly
well even with JavaScript disabled. We\'re excited to see how this
technology develops.
