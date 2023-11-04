---
title: "Why I Still Like Ruby (and a Few Things I Don’t Like)"
date: 2020-08-06T00:00:00+00:00
draft: false
canonical_url: https://www.viget.com/articles/why-i-still-like-ruby-and-a-few-things-i-dont-like/
featured: true
references:
- title: "When Should You NOT Use Rails?"
  url: https://codefol.io/posts/when-should-you-not-use-rails/
  date: 2023-11-04T17:36:55Z
  file: codefol-io-bskabg.txt
---

The Stack Overflow [2020 Developer
Survey](https://insights.stackoverflow.com/survey/2020#technology-most-loved-dreaded-and-wanted-languages-loved)
came out a couple months back, and while I don't put a ton of stock in
surveys like this, I was surprised to see Ruby seem to fare so poorly --
most notably its rank on the "most dreaded" list. Again, who cares
right, but it did make me take a step back and try to take an honest
assessment of Ruby's pros and cons, as someone who's been using Ruby
professionally for 13 years but loves playing around with other
languages and paradigms. First off, some things I really like.

### It's a great scripting language

Matz's original goal in creating Ruby was to build a truly
object-oriented scripting language[^1], and that's my
favorite use of the language: simple, reusable programs that automate
repetitive tasks. It has fantastic regex and unix support (check out
[`Open3`](https://docs.ruby-lang.org/en/2.0.0/Open3.html) as an
example). I might not always build Ruby apps, but I'll probably always
reach for it for scripting and glue code.

### A class is a little program

This one took me awhile to get my head around, and I'm not sure I'll do
a perfect job explaining it, but when a Ruby class gets loaded, it's
evaluated as a series of expressions from top-to-bottom, like a normal
program. This means you can, for example, define a class method and then
turn around and call it in the class' top-level source; in fact, this is
how things like `has_many` in Rails works -- you're just calling a class
method defined in the parent class. In other languages, you'd have to
reach for something like macros to accomplish this same functionality.

[Here's an alternate
explanation](https://mufid.github.io/blog/2016/ruby-class-evaluation/)
of what I'm getting at and [here's a cool
post](https://dev.to/baweaver/decorating-ruby-part-two-method-added-decoration-48mj)
that illustrates what sort of power this unlocks.

### The community is open source-focused

Ruby has a rich ecosystem of third-party code that Viget both benefits
from and contributes to, and with a few notable
exceptions[^2], it's all made available without the
expectation of direct profit. This means that you can pull a library
into your codebase and not have to worry about the funding status of the
company that built it (contrast with ventured-funded open-source like
[Gatsby](https://www.gatsbyjs.org/) and [Strapi](https://strapi.io/)).
Granted, with time, money, and a dedicated staff, the potential is there
to build better open source products than what small teams can do in
their free time, but in my experience, open source development and the
profit motive tend not to mix well.

### Bundler is good

It's simple, universal, and works well, and it makes it tough to get
into other languages that haven't figured this stuff out.

### It has a nice aesthetic

It's easy to make code that looks good (at least to my eye) and is easy
to understand. There's less temptation to spend a lot of time polishing
code the way I've experienced with some functional languages.

## And some things I don't like as much

Lest ye think I'm some diehard Ruby fan, I've got some gripes, as well.

### It's not universal

As I said, my favorite use of Ruby is as a scripting language, so it's
unfortunate that it doesn't come installed by default on most unix-y
systems, unlike Perl, Python, and Bash. If you want to share some Ruby
code with someone who isn't already a Ruby dev, you have to talk about,
like, asdf, rbenv, or Docker first.

### Functions aren't really first-class

You can write code in an FP style in Ruby, but there's a difference
between that and what you get in a truly functional language. I guess
the biggest difference is that a method and a lambda/block (I know
they're [a little
different](https://yehudakatz.com/2012/01/10/javascript-needs-blocks/)
don't @ me) are distinct things, and the block/yield syntax, while nice,
isn't as nice as just passing functions around. I wish I could just do:

```ruby
square = -> (x) { x * x }
[1, 2, 3].map(square)
```

Or even!

```ruby
[1, 2, 3].map(@object.square)
```

(Where `@object.square` gives me the handle to a function that then gets
passed each item in the array. I recognize this is incompatible with
optional parentheses but let me dream.)

### It is probably too flexible

Just like skiing, the most dangerous time to be a Ruby developer is the
"early intermediate" phase -- you've learned the syntax and language
features, and all of a sudden EVERYTHING is possible. Want to craft the
perfect DSL? Do it. Want to redefine what `+` does for your Integer
subclass? Do it. Want to open up a third-party library and inject a
custom header? You get my point.

As I've said, Ruby makes it easy to write nice-looking code, but it
takes restraint (and mistakes) to write maintanable code. I suppose the
same could be said about the programming discipline in general, but I
can see the appeal of simpler languages like Go.

### Type checking is cool and Ruby doesn't have it

The first languages I learned were C++ and Java, which formed my
opinions of explicit typing and compilation and made Ruby such a
revelation, but a lot has changed in the subsequent decade, and modern
typed languages are awesome. It'd be neat to be able to compile a
project and have some level of confidence about its correctness before
running the test suite. That said, I sure do appreciate the readability
of things like [RSpec](https://rspec.info/) that rely on the
dynamic/message-passing nature of Ruby. Hard to imagine writing
something as nice as this in, like, Haskell:

```ruby
it { is_expected.not_to allow_values("Landlord", "Tenant").for(:client_type) }
```

(As I was putting this post together, I became aware of a lot of
movement in the "typed Ruby" space, so we'll see where that goes. Check
out
[RBS](https://developer.squareup.com/blog/the-state-of-ruby-3-typing/)
and [Sorbet](https://sorbet.org/) for more info.)

------------------------------------------------------------------------

So those are my thoughts. In the end, it's probably best to know several
languages well in order to really be able to understand
strengths/weaknesses and pick the appropriate one for the task at hand.
If you're interested in other thoughts along these lines, you could
check out [this Reddit
thread](https://www.reddit.com/r/ruby/comments/hpta1o/i_am_tired_of_hearing_that_ruby_is_fine/)
(and [this
comment](https://www.reddit.com/r/ruby/comments/hpta1o/i_am_tired_of_hearing_that_ruby_is_fine/fxvfzgo/)
in particular) or [this blog
post](https://codefol.io/posts/when-should-you-not-use-rails/), but what
really matters is whether or not Ruby is suitable for your needs and
tastes, not what bloggers/commenters/survey-takers think.

[^1]: [*The History of Ruby*](https://www.sitepoint.com/history-ruby/)
[^2]: I.e. [Phusion Passenger](https://www.phusionpassenger.com/)
