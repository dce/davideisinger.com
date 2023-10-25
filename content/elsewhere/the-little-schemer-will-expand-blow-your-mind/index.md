---
title: "The Little Schemer Will Expand/Blow Your Mind"
date: 2017-09-21T00:00:00+00:00
draft: false
canonical_url: https://www.viget.com/articles/the-little-schemer-will-expand-blow-your-mind/
---

I thought I'd take a break from the usual web dev content we post here
to tell you about my favorite technical book, *The Little Schemer*, by
Daniel P. Friedman and Matthias Felleisen: why you should read it, how
you should read it, and a couple tools to help you on your journey.

## Why read *The Little Schemer*

**It teaches you recursion.** At its core, *TLS* is a book about
recursion \-- functions that call themselves with modified versions of
their inputs in order to obtain a result. If you're a working
developer, you've probably worked with recursive functions if you've
(for example) modified a deeply-nested JSON structure. *TLS* starts as a
gentle introduction to these concepts, but things quickly get out of
hand.

**It teaches you functional programming.** Again, if you program in a
language like Ruby or JavaScript, you write your fair share of anonymous
functions (or *lambdas* in the parlance of Scheme), but as you work
through the book, you'll use recursion to build lambdas that do some
pretty amazing things.

**It teaches you (a) Lisp.**
Scheme/[Racket](https://en.wikipedia.org/wiki/Racket_(programming_language))
is a fun little language that's (in this author's humble opinion) more
approachable than Common Lisp or Clojure. It'll teach you things like
prefix notation and how to make sure your parentheses match up. If you
like it, one of those other languages is a great next step.

**It's different, and it's fun.** *TLS* is *computer science* as a
distinct discipline from "making computers do stuff." It'd be a cool
book even if we didn't have modern personal computers. It's halfway
between a programming book and a collection of logic puzzles. It's
mind-expanding in a way that your typical animal drawing tech book
can't approach.

## How to read *The Little Schemer*

**Get a paper copy of the book.** You can find PDFs of the book pretty
easily, but do yourself a favor and pick up a dead-tree copy. Make
yourself a bookmark half as wide as the book, and use it to cover the
right side of each page as you work through the questions on the left.

**Actually write the code.** The book does a great job showing you how
to write increasingly complex functions, but if you want to get the most
out of it, write the functions yourself and then check your answers
against the book's.

**Run your code in the Racket REPL.** Put your functions into a file,
and then load them into the interactive Racket console so that you can
try them out with different inputs. I'll give you some tools to help
with this at the end.

**Skip the rote recursion explanations.** This book is a fantastic
introduction to recursion, but by the third or fourth in-depth
walkthrough of how a recursive function gets evaluated, you can probably
just skim. It's a little bit overkill.

## And some tools to help you get started

Once you've obtained a copy of the book, grab Racket
(`brew install racket`) and
[rlwrap](https://github.com/hanslub42/rlwrap) (`brew install rlwrap`),
subbing `brew` for your platform's package manager. Then you can start
an interactive session with `rlwrap racket -i`, which is a much nicer
experience than calling `racket -i` on its own. In true indieweb
fashion, I've put together a simple GitHub repo called [Little Schemer
Workbook](https://github.com/dce/little-schemer-workbook) to help you
get started.

So check out *The Little Schemer.* Just watch out for those jelly
stains.
