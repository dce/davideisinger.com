---
title: "Functional Programming in Ruby with Contracts"
date: 2015-03-31T00:00:00+00:00
draft: false
canonical_url: https://www.viget.com/articles/functional-programming-in-ruby-with-contracts/
---

I read Thomas Reynolds' [*My Weird
Ruby*](http://awardwinningfjords.com/2015/03/03/my-weird-ruby.html) a
week or two ago, and I **loved** it. I'd never heard of the
[Contracts](https://github.com/egonSchiele/contracts.ruby) gem, but
after reading the post and the [well-written
docs](http://egonschiele.github.io/contracts.ruby/), I couldn't wait to
try it out. I'd been doing some functional programming as part of our
ongoing programming challenge series, and saw an opportunity to use
Contracts to rewrite my Ruby solution to the [One-Time
Pad](/elsewhere/otp-a-language-agnostic-programming-challenge)
problem. Check out my [rewritten `encrypt`
program](https://github.com/vigetlabs/otp/blob/master/languages/Ruby/encrypt):

```ruby
 #!/usr/bin/env ruby

require "contracts"
include Contracts

Char = -> (c) { c.is_a?(String) && c.length == 1 }
Cycle = Enumerator::Lazy

Contract [Char, Char] => Num
def int_of_hex_chars(chars)
 chars.join.to_i(16)
end

Contract ArrayOf[Num] => String
def hex_string_of_ints(nums)
 nums.map { |n| n.to_s(16) }.join
end

Contract Cycle => Num
def get_mask(key)
 int_of_hex_chars key.first(2)
end

Contract [], Cycle => []
def encrypt(plaintext, key)
 []
end

Contract ArrayOf[Char], Cycle => ArrayOf[Num]
def encrypt(plaintext, key)
 char = plaintext.first.ord ^ get_mask(key)
 [char] + encrypt(plaintext.drop(1), key.drop(2))
end

plaintext = STDIN.read.chars
key = ARGV.last.chars.cycle.lazy

print hex_string_of_ints(encrypt(plaintext, key))
```

Pretty cool, yeah? Compare with this [Haskell
solution](https://github.com/vigetlabs/otp/blob/master/languages/Haskell/encrypt.hs).
Some highlights:

### Typechecking

At its most basic, Contracts offers typechecking on function input and
output. Give it the expected classes of the arguments and the return
value, and you'll get a nicely formatted error message if the function
is called with something else, or returns something else.

### Custom types with lambdas

Ruby has no concept of a single character data type -- running
`"string".chars` returns an array of single-character strings. We can
simulate a native char type using a lambda, as seen on line #6, which
says that the argument must be a string and must have a length of one.

### Tuples

If you're expecting an array of a specific length and type, you can
specify it, as I've done on line #9.

### Pattern matching

Rather than one `encrypt` method with a conditional to see if the list
is empty, we define the method twice: once for the base case (line #24)
and once for the recursive case (line #29). This keeps our functions
concise and allows us to do case-specific typechecking on the output.

### No unexpected `nil`

There's nothing worse than `undefined method 'foo' for nil:NilClass`,
except maybe littering your methods with presence checks. Using
Contracts, you can be sure that your functions aren't being called with
`nil`. If it happens that `nil` is an acceptable input to your function,
use `Maybe[Type]` à la Haskell.

### Lazy, circular lists

Unrelated to Contracts, but similarly inspired by *My Weird Ruby*, check
out the rotating encryption key made with
[`cycle`](http://ruby-doc.org/core-2.1.0/Enumerable.html#method-i-cycle)
and
[`lazy`](http://ruby-doc.org/core-2.1.0/Enumerable.html#method-i-lazy)
on line #36.

***

As a professional Ruby developer with an interest in strongly typed
functional languages, I'm totally psyched to start using Contracts on my
projects. While you don't get the benefits of compile-time checking, you
do get cleaner functions, better implicit documentation, and more
overall confidence about your code.

And even if Contracts or FP aren't your thing, from a broader
perspective, this demonstrates that **experimenting with other
programming paradigms makes you a better programmer in your primary
language.** It was so easy to see the utility and application of
Contracts while reading *My Weird Ruby*, which would not have been the
case had I not spent time with Haskell, OCaml, and Elixir.
