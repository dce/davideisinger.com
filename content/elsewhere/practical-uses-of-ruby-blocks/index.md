---
title: "Practical Uses of Ruby Blocks"
date: 2010-10-25T00:00:00+00:00
draft: false
needs_review: true
canonical_url: https://www.viget.com/articles/practical-uses-of-ruby-blocks/
---

Blocks are one of Ruby\'s defining features, and though we use them all
the time, a lot of developers are much more comfortable calling methods
that take blocks than writing them. Which is a shame, really, as
learning to use blocks in a tasteful manner is one of the best ways to
up your Ruby game. Here are a few examples extracted from a recent
project to give you a few ideas.

## `if_present?`

Often times, I'll want to assign a result to a variable and then execute
a block of code if that variable has a value. Here's the most
straightforward implementation:

    user = User.find_by_login(login) if user ... end 

Some people like to inline the assignment and conditional, but this
makes me ([and Ben](https://www.viget.com/extend/a-confusing-rubyism/))
stabby:

    if user = User.find_by_login(login) ... end 

To keep things concise *and* understandable, let's write a method on
`Object` that takes a block:

    class Object def if_present? yield self if present? end end 

This way, we can just say:

    User.find_by_login(login).if_present? do |user| ... end 

We use Rails' [present?](http://apidock.com/rails/Object/present%3F)
method rather than an explicit `nil?` check to ignore empty collections
and strings.

## `if_multiple_pages?`

Methods that take blocks are a great way to wrap up complex conditional
logic. I often have to generate pagination and previous/next links for
JavaScript-powered scrollers, which involves calculating the number of
pages and then, if there are multiple pages, displaying the links.
Here's a helper that calculates the number of pages and then passes the
page count into the provided block:

    def if_multiple_pages?(collection, per_page = 10) pages = (collection.size / (per_page || 10).to_f).ceil yield pages if pages > 1 end 

Use it like so:

    <% if_multiple_pages? Article.published do |pages| %> <ol> <% 1.upto(pages) do |page| %> <li><%= link_to page, "#" %></li> <% end %> </ol> <% end %> 

## `list_items_for`

As you saw above, Rails helpers that take blocks can help create more
elegant view code. Things get tricky when you want your helpers to
output markup, though. Here's a helper I made to create list items for a
collection with "first" and "last" classes on the appropriate elements:

    def list_items_for(collection, opts = {}, &block) opts.reverse_merge!(:first_class => "first", :last_class => "last") concat(collection.map { |item| html_class = [ opts[:class], (opts[:first_class] if item == collection.first), (opts[:last_class] if item == collection.last) ] content_tag :li, capture(item, &block), :class => html_class.compact * " " }.join) end 

Here it is in use:

    <% list_items_for Article.published.most_recent(4) do |article| %> <%= link_to article.title, article %> <% end %> 

Which outputs the following:

    <li class="first"><a href="/articles/4">Article #4</a></li> <li><a href="/articles/3">Article #3</a></li> <li><a href="/articles/2">Article #2</a></li> <li class="last"><a href="/articles/1">Article #1</a></li> 

Rather than yield, `list_items_for` uses
[concat](http://apidock.com/rails/ActionView/Helpers/TextHelper/concat)
and
[capture](http://apidock.com/rails/ActionView/Helpers/CaptureHelper/capture)
in order to get the generated markup where it needs to be.

Opportunities to use blocks in your code are everywhere once you start
to look for them, whether in simple cases, like the ones outlined above,
or more complex ones, like Justin\'s [block/exception tail call
optimization technique](https://gist.github.com/645951). If you've got
any good uses of blocks in your own work, put them in a
[gist](https://gist.github.com/) and link them up in the comments.
