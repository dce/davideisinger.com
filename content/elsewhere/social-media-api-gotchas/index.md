---
title: "Social Media API Gotchas"
date: 2010-09-13T00:00:00+00:00
draft: false
needs_review: true
canonical_url: https://www.viget.com/articles/social-media-api-gotchas/
---

I've been heads-down for the last few weeks developing the web site for
the new [PUMA Social](http://www.puma.com/social) campaign. A major part
of this site is a web-based game that rewards users for performing
activities on various sites across the internet, and as such, I've
become intimately familiar with the APIs of several popular web sites
and their various --- shall we say --- *quirks*. I've collected the most
egregious here with the hope that I can save the next developer a bit of
anguish.

## Facebook Graph API for "Likes" is busted {#facebook_graph_api_for_8220likes8221_is_busted}

Facebook's [Graph API](https://developers.facebook.com/docs/api) is
awesome. It's fantastic to see them embracing
[REST](https://en.wikipedia.org/wiki/Representational_State_Transfer)
and the open web. That said, the documentation doesn't paint an accurate
picture of the Graph API's progress, and there are aspects that aren't
ready for prime time. Specifically, the "Like" functionalty:

-   For a page (like
    [http://www.facebook.com/puma](https://www.facebook.com/puma)), you
    can retrieve a maximum of 500 fans, selected at random. For a page
    with more than 2.2 million fans, this is of ... *limited* use.

-   For an individual item like a status update or photo, you can
    retrieve a list of the people who've "liked" it, but it's a small
    subset of the people you can view on the site itself. You might
    think this is a question of privacy, but I found that some users who
    are returned without providing authentication information are
    omitted when authenticated.

-   For individual users, accessing the things they've "liked" only
    includes pages, not normal wall activity or pages elsewhere on the
    web.

## Facebook Tabs retrieve content with POST {#facebook_tabs_retrieve_content_with_post}

Facebook lets you put tabs on your page with content served from
third-party websites. They're understandably strict about what tags
you're allowed to use --- no `<script>` or `<body>` tags, for example
--- and they typically do a good job explaining what rules are being
violated.

On the other hand, I configured a Facebook app to pull in tab content
from our Ruby on Rails application and was greeted with the unhelpful
"We've encountered an error with the page you requested." It took a lot
of digging, but I discovered that Facebook retrieves tab content with
`POST` (rather than `GET`) requests, and what's more, it submits them
with a `Content-Type` header of "application/x-www-form-urlencoded,"
which triggers an InvalidAuthenticityToken exception if you save
anything to the database during the request/response cycle.

## Twitter Search API `from_user_id` is utter crap {#twitter_search_api_from_user_id_is_utter_crap}

Twitter has a fantastic API, with one glaring exception. Results from
the [search
API](http://apiwiki.twitter.com/Twitter-Search-API-Method:-search)
contain fields named `from_user` and `from_user_id`; `from_user` is the
user's Twitter handle and `from_user_id` is a made-up number that has
nothing to do with the user's actual user ID. This is apparently a
[known
issue](https://code.google.com/p/twitter-api/issues/detail?id=214) that
is too complicated to fix. Do yourself a favor and match by screen name
rather than unique ID.
