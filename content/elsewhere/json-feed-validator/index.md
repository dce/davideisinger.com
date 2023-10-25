---
title: "JSON Feed Is Cool (+ a Simple Tool to Create Your Own)"
date: 2017-08-02T00:00:00+00:00
draft: false
canonical_url: https://www.viget.com/articles/json-feed-validator/
---

A few months ago, Manton Reece and Brent Simmons [announced the creation
of JSON Feed](https://jsonfeed.org/2017/05/17/announcing_json_feed), a
new JSON-based syndication format similar to (but so much better than)
[RSS](https://en.wikipedia.org/wiki/RSS) and
[Atom](https://en.wikipedia.org/wiki/Atom_(standard)). One might
reasonably contend that Google killed feed-based content aggregation in
2013 when they end-of-lifed™ Google Reader, but RSS continues to enjoy
[underground
popularity](http://www.makeuseof.com/tag/rss-dead-look-numbers/) and
JSON Feed has the potential to make feed creation and consumption even
more widespread. So why are we[^1] so excited about it?

## JSON > XML

RSS and Atom are both XML-based formats, and as someone who's written
code to both produce and ingest these feeds, it's not how I'd choose to
spend a Saturday. Or even a Tuesday. Elements in XML have both
attributes and children, which is a mismatch for most modern languages'
native data structures. You end up having to use libraries like
[Nokogiri](http://www.nokogiri.org/) to write code like
`item.attributes["name"]` and `item.children[0]`. And producing a feed
usually involves a full-blown templating solution like ERB. Contrast
that with JSON, which maps perfectly to JavaScript objects (-\_-), Ruby
hashes/arrays, Elixir maps, etc., etc. Producing a feed becomes a call
to `.to_json`, and consuming one, `JSON.parse`.

## Flexibility

While still largely focused on content syndication, [the
spec](https://jsonfeed.org/version/1) includes support for plaintext and
title-less posts and custom extensions, meaning its potential uses are
myriad. Imagine a new generation of microblogs, Slack bots, and IoT
devices consuming and/or producing JSON feeds.

## Feeds Are (Still) Cool

Not to get too high up on my horse or whatever, but as a longtime web
nerd, I'm dismayed by how much content creation has migrated to walled
gardens like Facebook/Instagram/Twitter/Medium that make it super easy
to get content *in*, but very difficult to get it back *out*. [Twitter
killed RSS in 2012](http://mashable.com/2012/09/05/twitter-api-rss), and
have you ever tried to get a list of your most recent Instagram photos
programatically? I wouldn't. Owning your own content and sharing it
liberally is what the web was made for, and JSON Feed has the potential
to make it easy and fun to do. [It's how things should be. It's how they
could be.](https://www.youtube.com/watch?v=TgqiSBxvdws)

------------------------------------------------------------------------

## Your Turn

If this sounds at all interesting to you, read the
[announcement](https://jsonfeed.org/2017/05/17/announcing_json_feed) and
the [spec](https://jsonfeed.org/version/1), listen to this [interview
with the
creators](https://daringfireball.net/thetalkshow/2017/05/31/ep-192), and
**try out this [JSON Feed
Validator](https://json-feed-validator.herokuapp.com/) I put up this
week**. You can use the [Daring Fireball
feed](https://daringfireball.net/feeds/json) or create your own. It's
pretty simple right now, running your input against a schema I
downloaded from [JSON Schema Store](http://schemastore.org/json/), but
[suggestions and pull requests are
welcome](https://github.com/vigetlabs/json-feed-validator).

[^1]:  [The royal we, you know?](https://www.youtube.com/watch?v=VLR_TDO0FTg#t=45s)
