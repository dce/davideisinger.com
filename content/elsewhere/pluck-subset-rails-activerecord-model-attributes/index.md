---
title: "Use .pluck If You Only Need a Subset of Model Attributes"
date: 2014-08-20T00:00:00+00:00
draft: false
needs_review: true
canonical_url: https://www.viget.com/articles/pluck-subset-rails-activerecord-model-attributes/
---

*Despite some exciting advances in the field, like
[Node](http://nodejs.org/), [Redis](http://redis.io/), and
[Go](https://golang.org/), a well-structured relational database fronted
by a Rails or Sinatra (or Django, etc.) app is still one of the most
effective toolsets for building things for the web. In the coming weeks,
I'll be publishing a series of posts about how to be sure that you're
taking advantage of all your RDBMS has to offer.*

IF YOU ONLY REQUIRE a few attributes from a table, rather than
instantiating a collection of models and then running a `.map` over them
to get the data you need, it's much more efficient to use `.pluck` to
pull back only the attributes you need as an array. The benefits are
twofold: better SQL performance and less time and memory spent in
Rubyland.

To illustrate, let's use an app I've been working on that takes
[Harvest](http://www.getharvest.com/) data and generates reports. As a
baseline, here is the execution time and memory usage of `rails runner`
with a blank instruction:

    $ time rails runner ""
    real 0m2.053s
    user 0m1.666s
    sys 0m0.379s

    $ memory_profiler.sh rails runner ""
    Peak: 109240

In other words, it takes about two seconds and 100MB to boot up the app.
We calculate memory usage with a modified version of [this Unix
script](http://stackoverflow.com/a/1269490).

Now, consider a TimeEntry model in our time tracking application (of
which there are 314,420 in my local database). Let's say we need a list
of the dates of every single time entry in the system. A naïve approach
would look something like this:

    dates = TimeEntry.all.map { |entry| entry.logged_on }

It works, but seems a little slow:

    $ time rails runner "TimeEntry.all.map { |entry| entry.logged_on }"
    real 0m14.461s
    user 0m12.824s
    sys 0m0.994s

Almost 14.5 seconds. Not exactly webscale. And how about RAM usage?

    $ memory_profiler.sh rails runner "TimeEntry.all.map { |entry| entry.logged_on }"
    Peak: 1252180

About 1.25 gigabytes of RAM. Now, what if we use `.pluck` instead?

    dates = TimeEntry.pluck(:logged_on)

In terms of time, we see major improvements:

    $ time rails runner "TimeEntry.pluck(:logged_on)"
    real 0m4.123s
    user 0m3.418s
    sys 0m0.529s

So from roughly 15 seconds to about four. Similarly, for memory usage:

    $ memory_profiler.sh bundle exec rails runner "TimeEntry.pluck(:logged_on)"
    Peak: 384636

From 1.25GB to less than 400MB. When we subtract the overhead we
calculated earlier, we're going from 15 seconds of execution time to
two, and 1.15GB of RAM to 300MB.

## Using SQL Fragments {#usingsqlfragments}

As you might imagine, there's a lot of duplication among the dates on
which time entries are logged. What if we only want unique values? We'd
update our naïve approach to look like this:

    dates = TimeEntry.all.map { |entry| entry.logged_on }.uniq

When we profile this code, we see that it performs slightly worse than
the non-unique version:

    $ time rails runner "TimeEntry.all.map { |entry| entry.logged_on }.uniq"
    real 0m15.337s
    user 0m13.621s
    sys 0m1.021s

    $ memory_profiler.sh rails runner "TimeEntry.all.map { |entry| entry.logged_on }.uniq"
    Peak: 1278784

Instead, let's take advantage of `.pluck`'s ability to take a SQL
fragment rather than a symbolized column name:

    dates = TimeEntry.pluck("DISTINCT logged_on")

Profiling this code yields surprising results:

    $ time rails runner "TimeEntry.pluck('DISTINCT logged_on')"
    real 0m2.133s
    user 0m1.678s
    sys 0m0.369s

    $ memory_profiler.sh rails runner "TimeEntry.pluck('DISTNCT logged_on')"
    Peak: 107984

Both running time and memory usage are virtually identical to executing
the runner with a blank command, or, in other words, the result is
calculated at an incredibly low cost.

## Using `.pluck` Across Tables {#using.pluckacrosstables}

Requirements have changed, and now, instead of an array of timestamps,
we need an array of two-element arrays consisting of the timestamp and
the employee's last name, stored in the "employees" table. Our naïve
approach then becomes:

    dates = TimeEntry.all.map { |entry| [entry.logged_on, entry.employee.last_name] }

Go grab a cup of coffee, because this is going to take awhile.

    $ time rails runner "TimeEntry.all.map { |entry| [entry.logged_on, entry.employee.last_name] }"
    real 7m29.245s
    user 6m52.136s
    sys 0m15.601s

    memory_profiler.sh rails runner "TimeEntry.all.map { |entry| [entry.logged_on, entry.employee.last_name] }"
    Peak: 3052592

Yes, you're reading that correctly: 7.5 minutes and 3 gigs of RAM. We
can improve performance somewhat by taking advantage of ActiveRecord's
[eager
loading](http://guides.rubyonrails.org/active_record_querying.html#eager-loading-associations)
capabilities.

    dates = TimeEntry.includes(:employee).map { |entry| [entry.logged_on, entry.employee.last_name] }

Benchmarking this code, we see significant performance gains, since
we're going from over 300,000 SQL queries to two.

    $ time rails runner "TimeEntry.includes(:employee).map { |entry| [entry.logged_on, entry.employee.last_name] }"
    real 0m21.270s
    user 0m19.396s
    sys 0m1.174s

    $ memory_profiler.sh rails runner "TimeEntry.includes(:employee).map { |entry| [entry.logged_on, entry.employee.last_name] }"
    Peak: 1606204

Faster (from 7.5 minutes to 21 seconds), but certainly not fast enough.
Finally, with `.pluck`:

    dates = TimeEntry.includes(:employee).pluck(:logged_on, :last_name)

Benchmarks:

    $ time rails runner "TimeEntry.includes(:employee).pluck(:logged_on, :last_name)"
    real 0m4.180s
    user 0m3.414s
    sys 0m0.543s

    $ memory_profiler.sh rails runner "TimeEntry.includes(:employee).pluck(:logged_on, :last_name)"
    Peak: 407912

A hair over 4 seconds execution time and 400MB RAM -- hardly any more
expensive than without employee names.

## Conclusion

-   Prefer `.pluck` to instantiating a collection of ActiveRecord
    objects and then using `.map` to build an array of attributes.

-   `.pluck` can do more than simply pull back attributes on a single
    table: it can run SQL functions, pull attributes from joined tables,
    and tack on to any scope.

-   Whenever possible, let the database do the heavy lifting.
