---
title: "Getting (And Staying) Motivated to Code"
date: 2009-01-21T00:00:00+00:00
draft: false
canonical_url: https://www.viget.com/articles/motivated-to-code/
---

When you're working on code written by another programmer --- whether a
coworker, open source contributor, or (worst of all) *yourself* from six
months ago --- it's all too easy to get frustrated and fall into an
unproductive state. The following are some ways I've found to overcome
this apprehension and get down to business.

### Tiny Improvements, Tiny Commits

When confronted with a sprawling, outdated codebase, it's easy to get
overwhelmed. To get started, I suggest making a tiny improvement. Add a
[named
scoped](http://ryandaigle.com/articles/2008/3/24/what-s-new-in-edge-rails-has-finder-functionality).
Use a more advanced
[enumerable](http://www.ruby-doc.org/core/classes/Enumerable.html)
method. And, as soon as you've finished, commit it. Committing feels
great and really hammers home that you've accomplished something of
value. Additionally, committing increases momentum and gives you the
courage to take on larger changes.

### Make a List

In *Getting Things Done*, [David Allen](http://www.davidco.com/) says,

> You'll invariably feel a relieving of pressure about anything you have
> a commitment to change or do, when you decide on the very next
> physical action required to move it forward.

I like to take it a step further: envision the program as I want it to
be, and then list the steps it will take to get there. Even though the
list will change substantially along the way, having a path and a
destination removes a lot of the anxiety of working with unfamiliar
code.

To manage such lists, I love [Things](https://culturedcode.com/things/),
but a piece of paper works just as well.

### Delete Something

As projects grow and requirements change, a lot of code outlives its
usefulness; but it sticks around anyway because, on the surface, its
presence isn't hurting anything. I'm sure you've encountered this ---
hell, I'm sure you've got extraneous code in your current project. When
confronted with such code, delete it. Deleting unused code increases
readability, decreases the likelihood of bugs, and adds to your
understanding of the remaining code. But those reasons aside, it feels
*great*. If I suspect a method isn't being used anywhere, I'll do

```sh
grep -lir "method_name" app
```

to find all the places where the method name occurs.

### Stake your Claim

On one project, I couldn't do any feature development --- or even make
any commits --- until I'd rewritten the entire test suite to use
[Shoulda](http://thoughtbot.com/projects/shoulda/). It was mentally
draining work and took much longer than it shoulda (see what I did
there?). If you need to add functionality to one specific piece of the
site, take the time to address those classes and call it a victory. You
don't have to fix everything at once, and it's much easier to bring code
up to speed one class at a time. With every improvement you make, your
sense of ownership over the codebase will increase and so will your
motivation.

### In Closing

As Rails moves from an upstart framework to an established technology,
the number of legacy projects will only increase. But even outside the
scope of Rails development, or working with legacy code at all, I think
maintaining motivation is the biggest challenge we face as developers.
I'd love to hear your tips for getting and staying motivated to code.
