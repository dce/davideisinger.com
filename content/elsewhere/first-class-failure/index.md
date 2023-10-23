---
title: "First-Class Failure"
date: 2014-07-22T00:00:00+00:00
draft: false
needs_review: true
canonical_url: https://www.viget.com/articles/first-class-failure/
---

As a developer, nothing makes me more nervous than third-party
dependencies and things that can fail in unpredictable
ways^[1](%7Bfn:1:url%7D "see footnote"){#fnref:1 .footnote}^. More often
than not, these two go hand-in-hand, taking our elegant, robust
applications and dragging them down to the lowest common denominator of
the services they depend upon. A recent internal project called for
slurping in and then reporting against data from
[Harvest](http://www.getharvest.com/), our time tracking service of
choice and a fickle beast on its very best days.

I knew that both components (`/(im|re)porting/`) were prone to failure.
How to handle that failure in a graceful way, so that our users see
something more meaningful than a 500 page, and our developers have a
fighting chance at tracking and fixing the problem? Here's the approach
we took.

## Step 1: Model the processes {#step1:modeltheprocesses}

Rather than importing the data or generating the report with procedural
code, create ActiveRecord models for them. In our case, the models are
`HarvestImport` and `Report`. When a user initiates a data import or a
report generation, save a new record to the database *immediately*,
before doing any work.

## Step 2: Give 'em status {#step2:giveemstatus}

These models have a `status` column. We default it to "queued," since we
offload most of the work to a series of [Resque](http://resquework.org/)
tasks, but you can use "pending" or somesuch if that's more your speed.
They also have an `error` field for reasons that will become apparent
shortly.

## Step 3: Define an interface {#step3:defineaninterface}

Into both of these models, we include the following module:

    module ProcessingStatus
     def mark_processing
     update_attributes(status: "processing")
     end

     def mark_successful
     update_attributes(status: "success", error: nil)
     end

     def mark_failure(error)
     update_attributes(status: "failed", error: error.to_s)
     end

     def process(cleanup = nil)
     mark_processing
     yield
     mark_successful
     rescue => ex
     mark_failure(ex)
     ensure
     cleanup.try(:call)
     end
    end

Lines 2--12 should be self-explanatory: methods for setting the object's
status. The `mark_failure` method takes an exception object, which it
stores in the model's `error` field, and `mark_successful` clears said
error.

Line 14 (the `process` method) is where things get interesting. Calling
this method immediately marks the object "processing," and then yields
to the provided block. If the block executes without error, the object
is marked "success." If any^[2](#fn:2 "see footnote"){#fnref:2
.footnote}^ exception is thrown, the object marked "failure" and the
error message is logged. Either way, if a `cleanup` lambda is provided,
we call it (courtesy of Ruby's
[`ensure`](http://ruby.activeventure.com/usersguide/rg/ensure.html)
keyword).

## Step 4: Wrap it up {#step4:wrapitup}

Now we can wrap our nasty, fail-prone reporting code in a `process` call
for great justice.

    class ReportGenerator
     attr_accessor :report

     def generate_report
     report.process -> { File.delete(file_path) } do
     # do some fail-prone work
     end
     end

     # ...
    end

The benefits are almost too numerous to count: 1) no 500 pages, 2)
meaningful feedback for users, and 3) super detailed diagnostic info for
developers -- better than something like
[Honeybadger](https://www.honeybadger.io/), which doesn't provide nearly
the same level of context. (`-> { File.delete(file_path) }` is just a
little bit of file cleanup that should happen regardless of outcome.)

\* \* \*

I've always found it an exercise in futility to try to predict all the
ways a system can fail when integrating with an external dependency.
Being able to blanket rescue any exception and store it in a way that's
meaningful to users *and* developers has been hugely liberating and has
contributed to a seriously robust platform. This technique may not be
applicable in every case, but when it fits, [it's
good](https://www.youtube.com/watch?v=HNfciDzZTNM&t=1m40s).


------------------------------------------------------------------------

1.  ::: {#fn:1}
    Well, [almost
    nothing](https://github.com/github/hubot/blob/master/src/scripts/google-images.coffee#L5).
    [ ↩](#fnref:1 "return to article"){.reversefootnote}
    :::

2.  ::: {#fn:2}
    [Any descendent of
    `StandardError`](http://stackoverflow.com/a/10048406), in any event.
    [ ↩](#fnref:2 "return to article"){.reversefootnote}
    :::
