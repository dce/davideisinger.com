---
title: "Write You a Parser for Fun and Win"
date: 2013-11-26T00:00:00+00:00
draft: false
needs_review: true
canonical_url: https://www.viget.com/articles/write-you-a-parser-for-fun-and-win/
---

As a software developer, you're probably familiar with the concept of a
parser, at least at a high level. Maybe you took a course on compilers
in school, or downloaded a copy of [*Create Your Own Programming
Language*](http://createyourproglang.com), but this isn't the sort of
thing many of us get paid to work on. I'm writing this post to describe
a real-world web development problem to which creating a series of
parsers was the best, most elegant solution. This is more in-the-weeds
than I usually like to go with these things, but stick with me -- this
is cool stuff.

## The Problem

Our client, the [Chronicle of Higher Education](http://chronicle.com/),
[hired us](https://viget.com/work/chronicle-vitae) to build
[Vitae](http://chroniclevitae.com/), a series of tools for academics to
find and apply to jobs, chief among which is the *profile*, an online
résumé of sorts. I'm not sure when the last time you looked at a career
academic's CV was, but these suckers are *long*, packed with degrees,
publications, honors, etc. We created some slick [Backbone-powered
interactions](https://viget.com/extend/backbone-js-on-vitae) for
creating and editing individual items, but a user with 70 publications
still faced a long road to create her profile.

Since academics are accustomed to following well-defined formats (e.g.
bibliographies), [KV](https://viget.com/about/team/kvigneault) had the
idea of creating formats for each profile element, and giving users the
option to create and edit all their data of a given type at once, as
text. So, for example, a user might enter his degrees in the following
format:

    Duke University
    ; Ph.D.; Biomedical Engineering

    University of North Carolina
    2010; M.S.; Biology
    2007; B.S.; Biology

That is to say, the user has a bachelor's and a master's in Biology from
UNC, and is working on a Ph.D. in Biomedical Engineering at Duke.

## The Solution

My initial, naïve approach to processing this input involved splitting
it up by line and attempting to suss out what each line was supposed to
be. It quickly became apparent that this was untenable for even one
model, let alone the 15+ that we eventually needed.
[Chris](https://viget.com/about/team/cjones) suggested creating custom
parsers for each resource, an approach I'd initially written off as
being too heavy-handed for our needs.

What is a parser, you ask? [According to
Wikipedia](https://en.wikipedia.org/wiki/Parsing#Computer_languages),
it's

> a software component that takes input data (frequently text) and
> builds a data structure -- often some kind of parse tree, abstract
> syntax tree or other hierarchical structure -- giving a structural
> representation of the input, checking for correct syntax in the
> process.

Sounds about right. I investigated
[Treetop](http://treetop.rubyforge.org/), the most well-known Ruby
library for creating parsers, but I found it to be targeted more toward
building standalone tools rather than use inside a larger application.
Searching further, I found
[Parslet](http://kschiess.github.io/parslet/), a "small Ruby library for
constructing parsers in the PEG (Parsing Expression Grammar) fashion."
Parslet turned out to be the perfect tool for the job. Here, for
example, is a basic parser for the above degree input:

    class DegreeParser < Parslet::Parser
     root :degree_groups

     rule(:degree_groups) { degree_group.repeat(0, 1) >>
     additional_degrees.repeat(0) }

     rule(:degree_group) { institution_name >>
     (newline >> degree).repeat(1).as(:degrees_attributes) }

     rule(:additional_degrees) { blank_line.repeat(2) >> degree_group }

     rule(:institution_name) { line.as(:institution_name) }

     rule(:degree) { year.as(:year).maybe >>
     semicolon >>
     name >>
     semicolon >>
     field_of_study }

     rule(:name) { segment.as(:name) }
     rule(:field_of_study) { segment.as(:field_of_study) }

     rule(:year) { spaces >>
     match("[0-9]").repeat(4, 4) >>
     spaces }

     rule(:line) { spaces >>
     match('[^ \r\n]').repeat(1) >>
     match('[^\r\n]').repeat(0) }

     rule(:segment) { spaces >>
     match('[^ ;\r\n]').repeat(1) >>
     match('[^;\r\n]').repeat(0) }

     rule(:blank_line) { spaces >> newline >> spaces }
     rule(:newline) { str("\r").maybe >> str("\n") }
     rule(:semicolon) { str(";") }
     rule(:space) { str(" ") }
     rule(:spaces) { space.repeat(0) }
    end

Let's take this line-by-line:

**2:** the `root` directive tells the parser what rule to start parsing
with.

**4-5:** `degree_groups` is a Parslet rule. It can reference other
rules, Parslet instructions, or both. In this case, `degree_groups`, our
parsing root, is made up of zero or one `degree_group` followed by any
number of `additional_degrees`.

**7-8:** a `degree_group` is defined as an institution name followed by
one more more newline + degree combinations. The `.as` method defines
the keys in the resulting output hash. Use names that match up with your
ActiveRecord objects for great justice.

**10:** `additional_degrees` is just a blank line followed by another
`degree_group`.

**12:** `institution_name` makes use of our `line` directive (which
we'll discuss in a minute) and simply gives it a name.

**14-18:** Here's where a degree (e.g. "1997; M.S.; Psychology") is
defined. We use the `year` rule, defined on line 23 as four digits in a
row, give it the name "year," and make it optional with the `.maybe`
method. `.maybe` is similar to the `.repeat(0, 1)` we used earlier, the
difference being that the latter will always put its results in an
array. After that, we have a semicolon, the name of the degree, another
semicolon, and the field of study.

**20-21:** `name` and `field_of_study` are segments, text content
terminated by semicolons.

**23-25:** a `year` is exactly four digits with optional whitespace on
either side.

**27-29:** a `line` (used here for our institution name) is at least one
non-newline, non-whitespace character plus everything up to the next
newline.

**31-33:** a `segment` is like a `line`, except it also terminates at
semicolons.

**35-39:** here we put names to some literal string matches, like
semicolons, spaces, and newlines.

In the actual app, the common rules between parsers (year, segment,
newline, etc.) are part of a parent class so that only the
resource-specific instructions would be included in this parser. Here's
what we get when we pass our degree info to this new parser:

    [{:institution_name=>"Duke University"@0,
     :degrees_attributes=>
     [{:name=>" Ph.D."@17, :field_of_study=>" Biomedical Engineering"@24}]},
     {:institution_name=>"University of North Carolina"@49,
     :degrees_attributes=>
     [{:year=>"2010"@78, :name=>" M.S."@83, :field_of_study=>" Biology"@89},
     {:year=>"2007"@98, :name=>" B.S."@103, :field_of_study=>" Biology"@109}]}]

The values are Parslet nodes, and the `@XX` indicates where in the input
the rule was matched. With a little bit of string coercion, this output
can be fed directly into an ActiveRecord model. If the user's input is
invalid, Parslet makes it similarly straightforward to point out the
offending line.

------------------------------------------------------------------------

This component of Vitae was incredibly satisfying to work on, because it
solved a real-world issue for our users while scratching a nerdy
personal itch. I encourage you to learn more about parsers (and
[Parslet](http://kschiess.github.io/parslet/) specifically) and to look
for ways to use them in projects both personal and professional.
