---
title: "OTP: a Functional Approach (or Three)"
date: 2015-01-29T00:00:00+00:00
draft: false
canonical_url: https://www.viget.com/articles/otp-ocaml-haskell-elixir/
---

I intially started the [OTP
challenge](https://viget.com/extend/otp-a-language-agnostic-programming-challenge)
as a fun way to write some [OCaml](https://ocaml.org/). It was, so much
so that I wrote solutions in two other functional languages,
[Haskell](https://wiki.haskell.org/Haskell) and
[Elixir](http://elixir-lang.org/). I structured all three sets of
programs the same so that I could easily see their similarities and
differences. Check out the `encrypt` program in
[all](https://github.com/vigetlabs/otp/blob/master/languages/OCaml/encrypt.ml)
[three](https://github.com/vigetlabs/otp/blob/master/languages/Haskell/encrypt.hs)
[languages](https://github.com/vigetlabs/otp/blob/master/languages/Elixir/apps/encrypt/lib/encrypt.ex)
and then I'll share some of my favorite parts. Go ahead, I'll wait.

## Don't Cross the Streams

One tricky part of the OTP challenge is that you have to cycle over the
key if it's shorter than the plaintext. My initial approaches involved
passing around an offset and using the modulo operator, [like
this](https://github.com/vigetlabs/otp/blob/6d607129f78ccafa9a294ca04da9e4c8bf7b7cc1/decrypt.ml#L11-L14):

```ocaml
let get_mask key index =
  let c1 = List.nth key (index mod (List.length key))
  and c2 = List.nth key ((index + 1) mod (List.length key)) in
  int_from_hex_chars c1 c2
```

Pretty gross, huh? Fortunately, both
[Haskell](http://hackage.haskell.org/package/base-4.7.0.2/docs/Prelude.html#v:cycle)
and
[Elixir](http://elixir-lang.org/docs/master/elixir/Stream.html#cycle/1)
have built-in functionality for lazy, cyclical lists, and OCaml (with
the [Batteries](http://batteries.forge.ocamlcore.org/) library) has the
[Dllist](http://batteries.forge.ocamlcore.org/doc.preview:batteries-beta1/html/api/Dllist.html)
(doubly-linked list) data structure. The OCaml code above becomes
simply:


```ocaml
let get_mask key =
  let c1 = Dllist.get key
  and c2 = Dllist.get (Dllist.next key) in
  int_of_hex_chars c1 c2
```

No more passing around indexes or using `mod` to stay within the bounds
of the array -- the Dllist handles that for us.

Similarly, a naïve Elixir approach:

```elixir
def get_mask(key, index) do
  c1 = Enum.at(key, rem(index, length(key)))
  c2 = Enum.at(key, rem(index + 1, length(key)))
  int_of_hex_chars(c1, c2)
end
```

And with streams activated:

```elixir
def get_mask(key) do
  Enum.take(key, 2) |> int_of_hex_chars
end
```

Check out the source code
([OCaml](https://github.com/vigetlabs/otp/blob/master/languages/OCaml/encrypt.ml),
[Haskell](https://github.com/vigetlabs/otp/blob/master/languages/Haskell/encrypt.hs),
[Elixir](https://github.com/vigetlabs/otp/blob/master/languages/Elixir/apps/encrypt/lib/encrypt.ex))
to get a better sense of cyclical data structures in action.

## Partial Function Application

Most programming languages have a clear distinction between function
arguments (input) and return values (output). The line is less clear in
[ML](https://en.wikipedia.org/wiki/ML_%28programming_language%29)-derived
languages like Haskell and OCaml. Check this out (from Haskell's `ghci`
interactive shell):

```
Prelude> let add x y = x + y
Prelude> add 5 7
12
```

We create a function, `add`, that (seemingly) takes two arguments and
returns their sum.

```
Prelude> let add5 = add 5
Prelude> add5 7
12
```

But what's this? Using our existing `add` function, we've created
another function, `add5`, that takes a single argument and adds five to
it. So while `add` appears to take two arguments and sum them, it
actually takes one argument and returns a function that takes one
argument and adds it to the argument passed to the initial function.

When you inspect the type of `add`, you can see this lack of distinction
between input and output:

```
Prelude> :type add
add :: Num a => a -> a -> a
```

Haskell and OCaml use a concept called
[*currying*](https://en.wikipedia.org/wiki/Currying) or partial function
application. It's a pretty big departure from the C-derived languages
most of us are used to. Other languages may offer currying as [an
option](http://ruby-doc.org/core-2.1.1/Proc.html#method-i-curry), but
this is just how these languages work, out of the box, all of the time.

Let's see this concept in action. To convert a number to its hex
representation, you call `printf "%x" num`. To convert a whole list of
numbers, pass the partially applied function `printf "%x"` to `map`,
[like
so](https://github.com/vigetlabs/otp/blob/master/languages/Haskell/encrypt.hs#L12):

```haskell
hexStringOfInts nums = concat $ map (printf "%x") nums
```

For more info on currying/partial function application, check out
[*Learn You a Haskell for Great
Good*](http://learnyouahaskell.com/higher-order-functions).

## A Friendly Compiler

I learned to program with C++ and Java, where `gcc` and `javac` weren't
my friends -- they were jerks, making me jump through a bunch of hoops
without catching any actual issues (or so teenage Dave thought). I've
worked almost exclusively with interpreted languages in the intervening
10+ years, so it was fascinating to work with Haskell and OCaml,
languages with compilers that catch real issues. Here's my original
`decrypt` function in Haskell:

```haskell
decrypt ciphertext key = case ciphertext of
  [] -> []
  c1:c2:cs -> xor (intOfHexChars [c1, c2]) (getMask key) : decrypt cs (drop 2 key)
```

Using pattern matching, I pull off the first two characters of the
ciphertext and decrypt them against they key, and then recurse on the
rest of the ciphertext. If the list is empty, we're done. When I
compiled the code, I received the following:

```
decrypt.hs:16:26: Warning:
  Pattern match(es) are non-exhaustive
  In a case alternative: Patterns not matched: [_]
```

The Haskell compiler is telling me that I haven't accounted for a list
consisting of a single character. And sure enough, this is invalid input
that a user could nevertheless use to call the program. Adding the
following handles the failure and fixes the warning:

```haskell
 decrypt ciphertext key = case ciphertext of
   [] -> []
   [_] -> error "Invalid ciphertext"
   c1:c2:cs -> xor (intOfHexChars [c1, c2]) (getMask key) : decrypt cs (drop 2 key)
```

## Elixir's |> operator

According to [*Programming
Elixir*](https://pragprog.com/book/elixir/programming-elixir), the pipe
operator (`|>`)

> takes the result of the expression to its left and inserts it as the
> first parameter of the function invocation to its right.

It's borrowed from F#, so it's not an entirely novel concept, but it's
certainly new to me. To build our key, we want to take the first
argument passed into the program, convert it to a list of characters,
and then turn it to a cyclical stream. My initial approach looked
something like this:

```elixir
key = Stream.cycle(to_char_list(List.first(System.argv)))
```

Using the pipe operator, we can flip that around into something much
more readable:

```elixir
key = System.argv |> List.first |> to_char_list |> Stream.cycle
```

I like it. Reminds me of Unix pipes or any Western written language.
[Here's how I use the pipe operator in my encrypt
solution](https://github.com/vigetlabs/otp/blob/master/languages/Elixir/apps/encrypt/lib/encrypt.ex#L11-L17).

***

At the end of this process, I think Haskell offers the most elegant code
and [Elixir](https://www.viget.com/services/elixir) the most potential
for us at Viget to use professionally. OCaml offers a good middle ground
between theory and practice, though the lack of a robust standard
library is a [bummer, man](https://www.youtube.com/watch?v=24Vlt-lpVOY).

I had a great time writing and refactoring these solutions. I encourage
you to [check out the
code](https://github.com/vigetlabs/otp/tree/master/languages), fork the
repo, and take the challenge yourself.
