---
title: "HTML Sanitization In Rails That Actually Works"
date: 2009-11-23T00:00:00+00:00
draft: false
canonical_url: https://www.viget.com/articles/html-sanitization-in-rails-that-actually-works/
---

Assuming you don't want to simply escape everything, sanitizing user
input is one of the relative weak points of the Rails framework. On
[SpeakerRate](http://speakerrate.com/), where users can use
[Markdown](http://daringfireball.net/projects/markdown/) to format
comments and descriptions, we've run up against some of the limitations
of Rails' built-in sanitization features, so we decided to dig in and
fix it ourselves.

In creating our own sanitizer, our goals were threefold: we want to
**let a subset of HTML in**. As the [Markdown
documentation](http://daringfireball.net/projects/markdown/syntax#html)
clearly states, "for any markup that is not covered by Markdown's
syntax, you simply use HTML itself." In keeping with the Markdown
philosophy, we can't simply strip all HTML from incoming comments, so
the included
[HTML::WhiteListSanitizer](https://github.com/rails/rails/blob/master/actionpack/lib/action_controller/vendor/html-scanner/html/sanitizer.rb#LID60)
is the obvious starting point.

Additionally, we want to **escape, rather than remove, non-approved
tags**, since some commenters want to discuss the merits of, say,
[`<h2 class="h2">`](http://speakerrate.com/talks/1698-object-oriented-css#c797).
Contrary to its documentation, WhiteListSanitizer simply removes all
non-whitelisted tags. Someone opened a
[ticket](https://rails.lighthouseapp.com/projects/8994-ruby-on-rails/tickets/916)
about this issue in August of 2008 with an included patch, but the
ticket was marked as resolved without ever applying it. Probably for the
best, as the patch introduces a new bug.

Finally, we want to **escape unclosed tags even if they belong to the
whitelist**. An unclosed `<strong>` tag can wreak havoc on the rest of a
page, not to mention what a `<div>` can do. Self-closing tags are okay.

With these requirements in mind, we subclassed HTML::WhiteListSanitizer
and fixed it up. Introducing, then:

<img src="jason_statham.jpg" class="inline">

[**HTML::StathamSanitizer**](https://gist.github.com/241114).
User-generated markup, you're on notice: this sanitizer will take its
shirt off and use it to kick your ass. At this point, I've written more
about the code than code itself, so without further ado:

```ruby
module HTML
  class StathamSanitizer < WhiteListSanitizer

    protected

    def tokenize(text, options)
      super.map do |token|
        if token.is_a?(HTML::Tag) && options[:parent].include?(token.name)
          token.to_s.gsub(/</, "&lt;")
        else
          token
        end
      end
    end

    def process_node(node, result, options)
      result << case node
        when HTML::Tag
          if node.closing == :close && options[:parent].first == node.name
            options[:parent].shift
          elsif node.closing != :self
            options[:parent].unshift node.name
          end

          process_attributes_for node, options

          if options[:tags].include?(node.name)
            node
          else
            bad_tags.include?(node.name) ? nil : node.to_s.gsub(/</, "&lt;")
          end
        else
          bad_tags.include?(options[:parent].first) ? nil : node.to_s.gsub(/</, "&lt;")
      end
    end
  end
end
```

As always, download and fork [at the
'hub](https://gist.github.com/241114).
