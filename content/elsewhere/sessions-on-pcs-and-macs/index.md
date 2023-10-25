---
title: "Sessions on PCs and Macs"
date: 2009-02-09T00:00:00+00:00
draft: false
canonical_url: https://www.viget.com/articles/sessions-on-pcs-and-macs/
---

When switching from Windows to a Mac, one thing that takes some getting
used to is the difference between closing and quitting a program. On the
Mac, as one [Mac-Forums poster puts
it](http://www.mac-forums.com/forums/switcher-hangout/99903-does-pushing-red-gel-button-really-close-application.html),
"To put it simply...you *close* windows. You *quit* applications."
Windows draws [no such
distinction](http://www.macobserver.com/article/2008/07/03.6.shtml#435860)
--- the application ends when its last window is closed. This may not
seem like much of a difference, but it has serious potential
ramifications when dealing with browsers and sessions; to quote the
[Ruby on Rails
wiki](http://wiki.rubyonrails.org/rails/pages/HowtoChangeSessionOptions):

> You can control when the current session will expire by setting the
> :session_expires value with a Time object. **If not set, the session
> will terminate when the user's browser is closed.**

In other words, if you use the session to persist information like login
state, the user experience for an out-of-the-box Rails app is
dramatically different depending on what operating system is used to
access it (all IE jokes aside). I probably quit my browser three times a
week, whereas I close all browser windows closer to three times an hour.
Were I running Windows, this might not be an option.

On my two most recent projects, I've used Adam Salter's [Sliding
Sessions
plugin](https://github.com/adamsalter/sliding_sessions/tree/master),
which allows me to easily set the duration of the session during every
request. This way, I can set the session to expire two weeks after the
last request, independent of browser activity --- a much saner default
setup, in my opinion.

It's well-known that Mac users are [vastly over-represented among web
developers](http://www.webdirections.org/the-state-of-the-web-2008/browsers-and-operating-systems/#operating-systems),
so I think there's a distinct possibility that a silent majority of
users are receiving a sub-optimal user experience in many Rails
apps --- and nobody really seems concerned.
