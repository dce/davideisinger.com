---
title: "Convert a Ruby Method to a Lambda"
date: 2011-04-26T00:00:00+00:00
draft: false
canonical_url: https://www.viget.com/articles/convert-ruby-method-to-lambda/
---

Last week I tweeted:

> Convert a method to a lambda in Ruby: lambda(&method(:events_path)).
> OR JUST USE JAVASCRIPT.

It might not be clear what I was talking about or why it would be
useful, so allow me to elaborate. Say you've got the following bit of
Javascript:

```javascript
var ytmnd = function() {
  alert("you're the man now " + (arguments[0] || "dog"));
};
```

Calling `ytmnd()` gets us `you're the man now dog`, while
`ytmnd("david")` yields `you're the man now david`. Calling simply
`ytmnd` gives us a reference to the function that we're free to pass
around and call at a later time. Consider now the following Ruby code:

```ruby
def ytmnd(name = "dog")
  puts "you're the man now #{name}"
end
```

First, aren't default argument values and string interpolation awesome?
Love you, Ruby. Just as with our Javascript function, calling `ytmnd()`
prints "you're the man now dog", and `ytmnd("david")` also works as
you'd expect. But. BUT. Running `ytmnd` returns *not* a reference to the
method, but rather calls it outright, leaving you with nothing but Sean
Connery's timeless words.

To duplicate Javascript's behavior, you can convert the method to a
lambda with `sean = lambda(&method(:ytmnd))`. Now you've got something
you can call with `sean.call` or `sean.call("david")` and pass around
with `sean`.

BUT WAIT. Everything in Ruby is an object, even methods. And as it turns
out, a method object behaves very much like a lambda. So rather than
saying `sean = lambda(&method(:ytmnd))`, you can simply say
`sean = method(:ytmnd)`, and then call it as if it were a lambda with
`.call` or `[]`. Big ups to
[Justin](https://www.viget.com/about/team/jmarney/) for that knowledge
bomb.

### WHOOOO CARES

All contrivances aside, there are real-life instances where you'd want
to take advantage of this language feature. Imagine a Rails partial that
renders a list of filtered links for a given model. How would you tell
the partial where to send the links? You could pass in a string and use
old-school `:action` and `:controller` params or use `eval` (yuck). You
could create the lambda the long way with something like
`:base_url => lambda { |*args| articles_path(*args) }`, but using
`method(:articles_path)` accomplishes the same thing with much less line
noise.

I'm not sure it would have ever occurred to me to do something like this
before I got into Javascript. Just goes to show that if you want to get
better as a Rubyist, a great place to start is with a different language
entirely.
