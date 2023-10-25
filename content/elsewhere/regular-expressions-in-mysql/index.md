---
title: "Regular Expressions in MySQL"
date: 2011-09-28T00:00:00+00:00
draft: false
canonical_url: https://www.viget.com/articles/regular-expressions-in-mysql/
---

Did you know MySQL supports using [regular
expressions](https://en.wikipedia.org/wiki/Regular_expression) in
`SELECT` statements? I'm surprised at the number of developers who
don't, despite using SQL and regexes on a daily basis. That's not to say
that putting a regex into your SQL should be a daily occurrence. In
fact, it can [cause more problems than it
solves](https://en.wikiquote.org/wiki/Jamie_Zawinski#Attributed), but
it's a handy tool to have in your belt under certain circumstances.

## Basic Usage

Regular expressions in MySQL are invoked with the
[`REGEXP`](http://dev.mysql.com/doc/refman/5.1/en/regexp.html) keyword,
aliased to `RLIKE`. The most basic usage is a hardcoded regular
expression in the right hand side of a conditional clause, e.g.:

```sql
SELECT * FROM users WHERE email RLIKE '^[a-c].*[0-9]@'; 
```

This SQL would grab every user whose email address begins with 'a', 'b',
or 'c' and has a number as the final character of its local portion.

## Something More Advanced

The regex used with RLIKE does not need to be hardcoded into the SQL
statement, and can *in fact* be a column in the table being queried. In
a recent project, we were tasked with creating an interface for managing
redirect rules à la
[mod_rewrite](http://httpd.apache.org/docs/current/mod/mod_rewrite.html).
We were able to do the entire match in the database, using SQL like this
(albeit with a few more joins, groups and orders):

```sql
SELECT * FROM redirect_rules WHERE '/news' RLIKE pattern; 
```

In this case, '/news' is the incoming request path and `pattern` is the
column that stores the regular expression. In our benchmarks, we found
this approach to be much faster than doing the regular expression
matching in Ruby, mostly because of the lack of ActiveRecord overhead.

## Caveats

Using regular expressions in your SQL has the potential to be slow.
These queries can't use indexes, so a full table scan is required. If
you can get away with using `LIKE`, which has some regex-like
functionality, you should. As always: benchmark, benchmark, benchmark.

Additionally, MySQL supports
[POSIX](https://en.wikipedia.org/wiki/POSIX) regular expressions, not
[PCRE](http://www.pcre.org/) like Ruby. There are things (like negative
lookaheads) that you simply can't do, though you probably ought not to
be doing them in your SQL anyway.

## In PostgreSQL

Support for regular expressions in PostgreSQL is similar to that of
MySQL, though the syntax is different (e.g. `email ~ '^a'` instead of
`email RLIKE '^a'`). What's more, Postgres contains some useful
functions for working with regular expressions, like `substring` and
`regexp_replace`. See the
[documentation](http://www.postgresql.org/docs/9.0/static/functions-matching.html)
for more information.

## Conclusion

In certain circumstances, regular expressions in SQL are a handy
technique that can lead to faster, cleaner code. Don't use `RLIKE` when
`LIKE` will suffice and be sure to benchmark your queries with datasets
similar to the ones you'll be facing in production.
