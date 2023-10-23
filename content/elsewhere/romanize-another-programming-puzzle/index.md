---
title: "Romanize: Another Programming Puzzle"
date: 2015-03-06T00:00:00+00:00
draft: false
needs_review: true
canonical_url: https://www.viget.com/articles/romanize-another-programming-puzzle/
---

We had such a good time working through our [first programming
challenge](https://viget.com/extend/otp-a-language-agnostic-programming-challenge)
that we decided to put another one together. We had several ideas, but
[Pat](https://viget.com/about/team/preagan)'s idea of converting to and
from Roman numerals won out, and a few hours later,
[Romanize](https://github.com/vigetlabs/romanize) was born.

The name of the game is to write, in a language of your choice, a pair
of programs that work like this:

    > ./deromanize I
    1
    > ./deromanize II
    2
    > ./deromanize MCMIV
    1904

    > ./romanize 1
    I
    > ./romanize 2
    II
    > ./romanize 1904
    MCMIV

It\'s a deceptively difficult problem, especially if, like me, you only
understand how Roman numerals work in the vaguest sense. And it's one
thing to create a solution that passes the test suite, and another
entirely to write something concise and elegant -- going from Arabic to
Roman, especially, seems to defy refactoring.

We've created working solutions in ~~seven~~ ~~eight~~ ~~nine~~ ten
languages:

-   C (via [Steve132](https://github.com/Steve132))
-   Clojure
-   Elixir
-   Go
-   Haskell (plus check out [this cool
    thing](https://gist.github.com/sgronblo/e3d73a61c5dd968b7d29) from
    [sgronblo](https://github.com/sgronblo) using QuickCheck and Parsec)
-   OCaml
-   Node.js (via [Xylem](https://github.com/Xylem))
-   PHP
-   Ruby
-   Swift (shout out to [wasnotrice](https://github.com/wasnotrice))

What's gonna be number eleven? **You decide!** [Fork the
repo](https://github.com/vigetlabs/romanize) and give it your best shot.
When you're done, send us a PR.
