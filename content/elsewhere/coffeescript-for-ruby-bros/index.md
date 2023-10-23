---
title: "CoffeeScript for Ruby Bros"
date: 2010-08-06T00:00:00+00:00
draft: false
needs_review: true
canonical_url: https://www.viget.com/articles/coffeescript-for-ruby-bros/
---

Hello there, Ruby friend. You've perhaps heard of
[CoffeeScript](https://jashkenas.github.com/coffee-script/),
"JavaScript's less ostentatious kid brother," but it might *as yet* be
unclear why you'd want to stray from Ruby's loving embrace. Well,
friend, I've been playing with it off-and-on for the past few months,
and I've come to the following conclusion: **CoffeeScript combines the
simplicity of Javascript with the elegance of Ruby.**

## Syntax

Despite its compactness as a language, Javascript has always felt a bit
noisy to me. Its excessive punctuation is pretty much the only thing it
has in common with its namesake. CoffeeScript borrows from the syntaxes
of Ruby and Python to create a sort of minimalist Javascript. From
Python, we get significant whitespace and list comprehensions.

Otherwise, it's all Ruby: semicolons and parentheses around function
arguments are entirely optional. Like Ruby's `||=`, conditional
assignment is handled with `?=`. Conditionals can be inlined
(`something if something_else`). And every statement has an implicit
value, so `return` is unnecessary.

## Functions

Both Javascript and Ruby support functional programming. Ruby offers
numerous language features to make functional programming as concise as
possible, the drawback being the sheer number of ways to define a
function: at least six, by my count (`def`, `do/end`, `{ }`, `lambda`,
`Proc.new`, `proc`).

At the other extreme, Javascript offers but one way to define a
function: the `function` keyword. It's certainly simple, but especially
in callback-oriented code, you wind up writing `function` one hell of a
lot. CoffeeScript gives us the `->` operator, combining the brevity of
Ruby with the simplicity of Javascript:

    thrice: (f) -> f() f() f() thrice -> puts "OHAI" 

Which translates to:

    (function(){ var thrice; thrice = function(f) { f(); f(); return f(); }; thrice(function() { return puts("OHAI"); }); })(); 

I'll tell you what that is: MONEY. Money in the BANK.

## It's Node

Though not dependent upon it, CoffeeScript is built to run on top of
[Node.js](http://nodejs.org/). This means you can take advantage of all
the incredible work people are doing with Node, including the
[Express](http://expressjs.com/) web framework, the [Redis Node
Client](https://github.com/fictorial/redis-node-client), and
[Connect](https://github.com/senchalabs/connect), a middleware framework
along the lines of [Rack](http://rack.rubyforge.org/). What's more, its
integration with Node allows you to run CoffeeScript programs from the
command line just like you would Ruby code.

CoffeeScript is an exciting technology, as both a standalone language
and as a piece of a larger Node.js toolkit. Take a look at
[Defer](http://gfxmonk.net/2010/07/04/defer-taming-asynchronous-javascript-with-coffeescript.html)
to see what the language might soon be capable of, and if you're
participating in this year's [Node.js
Knockout](http://nodeknockout.com/), watch out for the
[Rocketpants](http://nodeknockout.com/teams/2eb41a4c31f50c044a280000).
