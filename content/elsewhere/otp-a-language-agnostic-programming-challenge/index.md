---
title: "OTP: a Language-Agnostic Programming Challenge"
date: 2015-01-26T00:00:00+00:00
draft: false
canonical_url: https://www.viget.com/articles/otp-a-language-agnostic-programming-challenge/
---

We spend our days writing Ruby and JavaScript (and love it), but we're
always looking for what's next or just what's nerdy and interesting. We
have folks exploring Rust, Go, D and Elixir, to name a few. I'm
personally interested in strongly-typed functional languages like
Haskell and OCaml, but I've had little success getting through their
corresponding [animal books](http://www.oreilly.com/). I decided that if
I was going to get serious about learning this stuff, I needed a real
problem to solve.

Inspired by an [online course on
Cryptography](https://www.coursera.org/course/crypto), I specced out a
simple [one-time pad](https://en.wikipedia.org/wiki/One-time_pad)
encryptor/decryptor, [pushed it up to
GitHub](https://github.com/vigetlabs/otp) and issued a challenge to the
whole Viget dev team: write a pair of programs in your language of
choice to encrypt and decrypt a message from the command line.

## The Challenge

When you [exclusive or](https://en.wikipedia.org/wiki/Exclusive_or)
(XOR) a value by a second value, and then XOR the resulting value by the
second value, you get the original value back. Suppose you and I want to
exchange a secret message, the word "hi", and we've agreed on a secret
key, the hexadecimal number `b33f` (or in binary, 1011 0011 0011 1111).

**To encrypt:**

1.  Convert the plaintext ("hi") to its corresponding [ASCII
    values](https://en.wikipedia.org/wiki/ASCII#ASCII_printable_code_chart)
    ("h" becomes 104 or 0110 1000, "i" 105 or 0110 1001).

2.  XOR the plaintext and the key:

        Plaintext: 0110 1000 0110 1001
        Key: 1011 0011 0011 1111
        XOR: 1101 1011 0101 0110

3.  Convert the result to hexadecimal:

        1101 = 13 = d
        1011 = 11 = b
        0101 = 5 = 5
        0110 = 6 = 6

4.  So the resulting ciphertext is "db56".

**To decrypt:**

1.  Expand the ciphertext and key to their binary forms, and XOR:

        Ciphertext: 1101 1011 0101 0110
        Key: 1011 0011 0011 1111
        XOR: 0110 1000 0110 1001

2.  Convert the resulting binary numbers to their corresponding ASCII
    values:

        0110 1000 = 104 = h
        0110 1001 = 105 = i

3.  So, as expected, the resulting plaintext is "hi".

The [Wikipedia](https://en.wikipedia.org/wiki/One-time_pad) page plus
the [project's
README](https://github.com/vigetlabs/otp#one-time-pad-otp) provide more
detail. It's a simple problem conceptually, but in order to create a
solution that passes the test suite, you'll need to figure out:

-   Creating a basic command-line executable
-   Reading from `STDIN` and `ARGV`
-   String manipulation
-   Bitwise operators
-   Converting to and from hexadecimal

***

As of today, we've created solutions in [~~eleven~~ ~~twelve~~ thirteen
languages](https://github.com/vigetlabs/otp/tree/master/languages):

-   [C](https://viget.com/extend/otp-the-fun-and-frustration-of-c)
-   D
-   [Elixir](/elsewhere/otp-ocaml-haskell-elixir)
-   Go
-   [Haskell](/elsewhere/otp-ocaml-haskell-elixir)
-   JavaScript 5
-   JavaScript 6
-   Julia
-   [Matlab](https://viget.com/extend/otp-matlab-solution-in-one-or-two-lines)
-   [OCaml](/elsewhere/otp-ocaml-haskell-elixir)
-   Ruby
-   Rust
-   Swift (thanks [wasnotrice](https://github.com/wasnotrice)!)

The results are varied and fascinating -- stay tuned for future posts
about some of our solutions. [In the
meantime](https://www.youtube.com/watch?v=TDkhl-CgETg), we'd love to see
how you approach the problem, whether in a new language or one we've
already attempted. [Fork the repo](https://github.com/vigetlabs/otp) and
show us what you've got!
