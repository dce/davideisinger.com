---
title: "Things About Which The Viget Devs Are Excited (May 2020 Edition)"
date: 2020-05-14T00:00:00+00:00
draft: false
canonical_url: https://www.viget.com/articles/things-about-which-the-viget-devs-are-excited-may-2020-edition/
---

A couple months back, the Viget dev team convened in central Virginia to
reflect on the year and plan for the future. As part of the meeting, we
did a little show-and-tell, where everyone got the chance to talk about
a technology or resource that's attracted their interest. Needless to
say, *plans have changed*, but what hasn't changed are our collective
curiosity about nerdy things and our desire to share them with one
another and with you, internet person. So with that said, here's
what's got us excited in the world of programming, technology, and web
development.

## [Annie](https://www.viget.com/about/team/akiley)

I'm excited about Wagtail CMS for Django projects. It provides a lot of
high-value content management features (hello permissions management and
photo cropping) so you don't need to reinvent the wheel, but it lets you
customize behavior when you need to. We've had two projects lately that
need a sophisticated CMS to manage data that we serve through an API,
and Wagtail has allowed us to get a solid CMS up and running and focus
on the business logic behind the API.

-   <https://wagtail.io/>

## [Chris M.](https://www.viget.com/about/team/cmanning)

Svelte is a component framework for building user interfaces. It's
purpose is similar to other frameworks like React and Vue, but I'm
excited about Svelte because of its differences.

For example, instead of a virtual DOM, Svelte compiles your component to
more performant imperative code. And Svelte is reactive, so updating a
variable is just that: there's no need to call `setState` or a similar
API to trigger updates. Differences like these offer less boilerplate
and better performance from the start.

The Svelte community is also working on Sapper, an application framework
for server-side rendering similar to Next.js.

-   <https://svelte.dev/>
-   <https://sapper.svelte.dev/>

## [Danny](https://www.viget.com/about/team/dbrown)

I've been researching the Golang MVC framework, Revel. At Viget, we
often use Ruby on Rails for any projects that need an MVC framework. I
enjoy programming in Go, so I started researching what they have to
offer in that department. Revel seemed to be created to be mimic Rails
or other MVC frameworks, which made it very easy to pick up for a Rails
developer. The main differences come in the language distinctions
between Golang and Ruby.

Namely, the statically-typed, very explicit Go contrasts greatly with
Ruby when comparing similar features. For most cases, it takes more
lines of code in Go to achieve similar things, though that is not
necessarily a bad thing. Additionally, standard Go ships with an
incredible amount of useful packages, making complex features in
Go/Revel require fewer dependencies. Finally, Go is an incredibly fast
language. For very large projects, Go is often a great language to use,
so that you can harness its power. However, for smaller-scale projects,
it can be a bit overkill.

-   <https://revel.github.io/>

## [David](https://www.viget.com/about/team/deisinger)

I'm excited about [Manjaro Linux running the i3 tiling window
manager](https://manjaro.org/download/community/i3/). I picked up an old
Thinkpad and installed this combo, and I've been impressed with how fun
and usable it is, and how well it runs on a circa-2008 computer. For
terminal-focused workflows, this setup is good as hell. Granted, it's
Linux, so there's still a fair bit of fiddling required to get things
working exactly as you'd like, but for a hobbyist OS nerd like me,
that's all part of the fun.

## [Doug](https://www.viget.com/about/team/davery)

The improvements to iOS Machine Learning have been exciting --- it's
easier than ever to build iOS apps that can recognize speech, identify
objects, and even train themselves on-device without needing a network.
The Create ML tool simplifies the model training flow, allowing any iOS
dev to jump in with very little experience.

ML unlocks powerful capabilities for mobile apps, allowing apps to
recognize and act on data the way a user would. It's a fascinating area
of native app dev, and one we'll see a lot more of in apps over the next
few years.

-   <https://developer.apple.com/machine-learning/core-ml/>
-   <https://developer.apple.com/videos/play/wwdc2018/703>
-   [https://developer.apple.com/documentation/createml/…](https://developer.apple.com/documentation/createml/creating_an_image_classifier_model)

## [Dylan](https://www.viget.com/about/team/dlederle-ensign)

I've been diving into LiveView, a new library for the Elixir web
framework, Phoenix. It enables the sort of fluid, realtime interfaces
we'd normally make with a Javascript framework like React, without
writing JavaScript by hand. Instead, the logic stays on the server and
the LiveView.js library is responsible for updating the DOM when state
changes. It's a cool new approach that could be a nice option in
between static server rendered pages and a full single page app
framework.

-   <https://www.viget.com/articles/what-is-phoenix-liveview/>
-   <https://blog.appsignal.com/2019/06/18/elixir-alchemy-building-go-with-phoenix-live-view.html>

## [Eli](https://www.viget.com/about/team/efatsi)

I've been building a "Connected Chessboard" off and on for the last 3
years with my brother. There's a lot of fun stuff on the firmware side
of things, using OO concepts to organize move detection using analog
light sensors. But the coolest thing I recently learned was how to make
use of [analog multiplexers](https://www.sparkfun.com/products/13906).
With three input pins, you provide a binary representation of a number
0-7, and the multiplexer then performs magic to pipe input/output data
through one of 8 pins. By linking 8 of these together, and then a 9th
multiplexer on top of those (thanks chessboard for being an 8x8 square),
I can take 64 analog readings using only 7 IO pins. #how-neat-is-that

## [Joe](https://www.viget.com/about/team/jjackson)

I'm a self-taught developer and I've explored and been interested in
some foundational topics in CS, like boolean logic, assembly/machine
code, and compiler design. This book, [The Elements of Computing
Systems: Building a Modern Computer from First
Principles](https://www.amazon.com/Elements-Computing-Systems-Building-Principles/dp/0262640686/ref=ed_oe_p),
and its [companion website](https://www.nand2tetris.org/) is a great
resource that gives you enough depth in everything from circuit design,
to compiler design.

## [Margaret](https://www.viget.com/about/team/mwilliford)

I've enjoyed working with Administrate, a lightweight Rails engine that
helps you put together an admin dashboard built by Thoughtbot. It solves
the same problem as Active Admin, but without a custom DSL. It's easy to
quickly throw up an admin interface for resource CRUD, but anything
beyond your most simple use case will require going custom. The
documentation is straightforward and sufficient, and lays out how to go
about customizing and building on top of the existing framework. The
source code is available on Github and easy to follow. I haven't tried
it with a large scale application, but for getting something small-ish
up and running quickly, it's a great option.

## [Shaan](https://www.viget.com/about/team/ssavarirayan)

I'm excited about Particle's embedded IoT development platform. We
built almost of of our hardware projects using Particle's stack, and
there's a good reason for it. They sell microcontrollers that come
out-the-box with WiFi and Bluetooth connectivity built-in. They make it
incredibly easy to build connected devices, by allowing you to expose
functions on your device to the web through their API. Your web app can
then make calls to your device to either trigger functionality or get
data. It's really easy to manage multiple devices and they make remote
deployment of your device (setting up WiFi, etc.) a piece of cake.

-   <https://docs.particle.io/quickstart/photon/>

## [Sol](https://www.viget.com/about/team/shawk)

I'm excited about old things that are still really good. It's easy to
get lost in the hype of the new and shiny, but our industry has a long
history and many common problems have been solved over and over by
people smarter than you or I. One of those problems is running tasks
intelligently based on changed files. The battle-tested tool that has
solved this problem for decades is
[Make](https://www.gnu.org/software/make/manual/make.html). Even if you
aren't leveraging the intelligence around caching intermediary targets,
you can use Make for project-specific aliases to save yourself and your
coworkers some brain cycles remembering and typing out common commands
(e.g. across a number of other tools used for a given project).

TL;DR Make is old and still great.

------------------------------------------------------------------------

So there it is, some cool tech from your friendly Viget dev team. Hope
you found something worth exploring further, and if you like technology
and camaraderie, [we're always looking for great, nerdy
folks](https://www.viget.com/careers/).
