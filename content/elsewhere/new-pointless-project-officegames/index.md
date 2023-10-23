---
title: "New Pointless Project: OfficeGames"
date: 2012-02-28T00:00:00+00:00
draft: false
needs_review: true
canonical_url: https://www.viget.com/articles/new-pointless-project-officegames/
---

*This post originally appeared on [Pointless
Corp](http://pointlesscorp.com/).*

We're a competitive company, so for this year's [Pointless
Weekend](http://www.pointlesscorp.com/blog/2012-pointless-weekend-kicks-off),
the team in Viget's Durham office thought it'd be cool to put together a
simple app for keeping track of competitions around the office. 48 hours
later (give or take), we launched [OfficeGames](http://officegam.es/).
We're proud of this product, and plan to continue improving it in the
coming weeks. Some of the highlights for me:

## Everyone Doing Everything

We're a highly collaborative company, but by and large, when it comes to
client work, everyone on the team has a fairly narrow role.
[Zachary](https://www.viget.com/about/team/zporter) writes Ruby code.
[Todd](https://www.viget.com/about/team/tmoy) does UX.
[Jeremy](https://www.viget.com/about/team/jfrank) focuses on the front
end. Not so for Pointless weekend -- UX, design, and development duties
were spread out across the entire team. Everyone had the repo checked
out and was committing code.

## Responsive Design with Bootstrap

We used Twitter's [Bootstrap](https://twitter.github.com/bootstrap/)
framework to build our app. The result is a responsive design that
shines on the iPhone but holds up well on larger screens. I was
impressed with how quickly we were able to get a decent-looking site
together, and how well the framework held up once Jeremy and
[Doug](https://www.viget.com/about/team/davery) started implementing
some of [Mark](https://www.viget.com/about/team/msteinruck)'s design
ideas.

## Rails as a Mature Framework

I was impressed with the way everything came together on the backend. It
seems to me that we're finally realizing the promise of the Rails
framework: common libraries that handle the application plumbing, while
still being fully customizable, so developers can quickly knock out the
boilerplate and then focus on the unique aspects of their applications.
We used [SimplestAuth](https://github.com/vigetlabs/simplest_auth),
[InheritedResources](https://github.com/josevalim/inherited_resources),
and [SimpleForm](https://github.com/plataformatec/simple_form) to great
effect.

Sign your office up for [OfficeGames](http://officegam.es/) and then add
your coworkers to start tracking scores. Let us know what you think!
