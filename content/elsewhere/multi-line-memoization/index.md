---
title: "Multi-line Memoization"
date: 2009-01-05T00:00:00+00:00
draft: false
canonical_url: https://www.viget.com/articles/multi-line-memoization/
---

Here's a quick tip that came out of a code review we did last week. One
easy way to add caching to your Ruby app is to
[memoize](https://en.wikipedia.org/wiki/Memoization) the results of
computationally expensive methods:

```ruby
def foo
  @foo ||= expensive_method
end
```

The first time the method is called, `@foo` will be `nil`, so
`expensive_method` will be called and its result stored in `@foo`. On
subsequent calls, `@foo` will have a value, so the call to
`expensive_method` will be bypassed. This works well for one-liners, but
what if our method requires multiple lines to determine its result?

```ruby
def foo
  arg1 = expensive_method_1
  arg2 = expensive_method_2
  expensive_method_3(arg1, arg2)
end
```

A first attempt at memoization yields this:

```ruby
def foo
  unless @foo
    arg1 = expensive_method_1
    arg2 = expensive_method_2
    @foo = expensive_method_3(arg1, arg2)
  end

  @foo
end
```

To me, using `@foo` three times obscures the intent of the method. Let's
do this instead:

```ruby
def foo
  @foo ||= begin
    arg1 = expensive_method_1
    arg2 = expensive_method_2
    expensive_method_3(arg1, arg2)
  end
end
```

This clarifies the role of `@foo` and reduces LOC. Of course, if you use
the Rails built-in [`memoize`
method](http://ryandaigle.com/articles/2008/7/16/what-s-new-in-edge-rails-memoization),
you can avoid accessing these instance variables entirely, but this
technique has utility in situations where requiring ActiveSupport would
be overkill.
