---
title: "PUMA on Redis"
date: 2011-07-27T00:00:00+00:00
draft: false
canonical_url: https://www.viget.com/articles/puma-on-redis/
---

A few weeks ago, we celebrated the launch of [the new
PUMA.com](https://www.viget.com/blog/relaunching-pumacom-startup-style/),
the culmination of a nearly two-year effort here at Viget. The whole
site is driven by a CMS written in Rails, and I'm very proud of the
technological platform we've developed. I want to focus on one piece of
that platform, [Redis](http://redis.io/), and how it makes the site both
rock solid and screaming fast.

## Fragment Caching

The app was initially created to serve category marketing sites like
[Running](http://www.puma.com/running) and
[Football](http://www.puma.com/football). When we set out to overhaul it
to serve the main PUMA site, we knew performance was of paramount
importance. We made extensive use of fragment caching throughout the
site, using Redis as our cache store. [Some
claim](http://stackoverflow.com/questions/4221735/rails-and-caching-is-it-easy-to-switch-between-memcache-and-redis/4342279#4342279)
that Redis is not as well suited for this purpose as Memcached, but it
held up well in our pre-launch testing and continues to perform well in
production.

We used Redis as our cache store for two reasons. First, we were already
using it for other purposes, so reusing it kept the technology stack
simpler. But more importantly, Redis' wildcard key matching makes cache
expiration a snap. It's well known that cache expiration is one of [two
hard things in computer
science](http://martinfowler.com/bliki/TwoHardThings.html), but using
wildcard key searching, it's dirt simple to pull back all keys that
begin with "views" and contain the word "articles" and expire them
everytime an article is changed. Memcached has no such ability.

## API Caching

The PUMA site leverages third-party APIs to pull in product
availability, retail store information, and marketing campaigns, among
other things. External APIs are good for only two things: being slow and
returning unexpected results. In a defensive masterstroke, we developed
[CacheBar](https://github.com/vigetlabs/cachebar) to keep our responses
speedy and stable.

CacheBar sits between [HTTParty](http://httparty.rubyforge.org/) and the
web. When it receives a successful response, it stores it in Redis in
two places: as a normal string value with an expiration set on a per-API
basis (usually between an hour and a day) and in a hash of all that
API's responses. When the primary key expires, we attempt to fetch the
data from the API. Successful responses are again stored in both
locations, but if the response is unsuccessful, we pull the saved
response from the hash and set it as the value for the primary key with
a five-minute expiration. This way, we avoid the backup that happens as
a result of too many slow responses.

More information is available on the [CacheBar GitHub
page](https://github.com/vigetlabs/cachebar).

## Data Structures

The PUMA app uses Redis' hashes, lists, and sets (sorted and unsorted)
as well as normal string values. Having all these data structures at our
disposal has proven incredibly useful, not to mention damn fun to use.

***

Redis has far exceeded my expectations in both usefulness and
performance. Add it to your stack, and you'll be amazed at the ways it
can make your app faster and more robust.

If you're in North Carolina's Triangle region and you'd like to hear
more about the PUMA project, come out to tomorrow night's [Refresh the
Triangle](http://refreshthetriangle.org/) meeting, where I'll be talking
about this stuff alongside several other team members.
