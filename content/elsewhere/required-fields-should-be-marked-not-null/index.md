---
title: "Required Fields Should Be Marked NOT NULL"
date: 2014-09-25T00:00:00+00:00
draft: false
needs_review: true
canonical_url: https://www.viget.com/articles/required-fields-should-be-marked-not-null/
---

*Despite some exciting advances in the field, like
[Node](http://nodejs.org/), [Redis](http://redis.io/), and
[Go](https://golang.org/), a well-structured relational database fronted
by a Rails or Sinatra (or Django, etc.) app is still one of the most
effective toolsets for building things for the web. In the coming weeks,
I'll be publishing a series of posts about how to be sure that you're
taking advantage of all your RDBMS has to offer.*

A "NOT NULL constraint" enforces that a database column does not accept
null values. Null, according to
[Wikipedia](https://en.wikipedia.org/wiki/Null_(SQL)), is

> a special marker used in Structured Query Language (SQL) to indicate
> that a data value does not exist in the database. Introduced by the
> creator of the relational database model, E. F. Codd, SQL Null serves
> to fulfill the requirement that all true relational database
> management systems (RDBMS) support a representation of "missing
> information and inapplicable information."

One could make the argument that null constraints in the database are
unnecessary, since Rails includes the `presence` validation. What's
more, the `presence` validation handles blank (e.g. empty string) values
that null constraints do not. For several reasons that I will lay out
through the rest of this section, I contend that null constraints and
presence validations should not be mutually exclusive, and in fact, **if
an attribute's presence is required at the model level, its
corresponding database column should always require a non-null value.**

## Why use non-null columns for required fields? {#whyusenon-nullcolumnsforrequiredfields}

### Data Confidence {#dataconfidence}

The primary reason for using NOT NULL constraints is to have confidence
that your data has no missing values. Simply using a `presence`
validation offers no such confidence. For example,
[`update_attribute`](http://apidock.com/rails/ActiveRecord/Persistence/update_attribute)
ignores validations, as does `save` if you call it with the
[`validate: false`](http://apidock.com/rails/v4.0.2/ActiveRecord/Persistence/save)
option. Additionally, database migrations that manipulate the schema
with raw SQL using `execute` bypass validations.

### Undefined method 'foo' for nil:NilClass {#undefinedmethodfoofornil:nilclass}

One of my biggest developer pet peeves is seeing a
`undefined method 'foo' for nil:NilClass` come through in our error
tracking service du jour. Someone assumed that a model's association
would always be present, and one way or another, that assumption turned
out to be false. The merits of the [Law of
Demeter](https://en.wikipedia.org/wiki/Law_of_Demeter) are beyond the
scope of this post, but suffice it to say that if you're going to say
something like `@athlete.team.name` in your code, you better be damn
sure that a) the athlete's `team_id` has a value and b) it corresponds
to the ID of an actual team. We'll get to that second bit in our
discussion of foreign key constraints in a later post, but the first
part, ensuring that `team_id` has a value, demands a `NOT NULL` column.

### Migration Issues {#migrationissues}

Another benefit of using `NOT NULL` constraints is that they force you
to deal with data migration issues. Suppose a change request comes in to
add a required `age` attribute to the `Employee` model. The easy
approach would be to add the column, allow it to be null, and add a
`presence` validation to the model. This works fine for new employees,
but all of your existing employees are now in an invalid state. If, for
example, an employee then attempts a password reset, updating their
`password_reset_token` field would fail due to the missing age value.

If you'd created the `age` column to require a non-null value, you would
have been forced to deal with the issue of existing users immediately
and thus avoided this issue. That said, there's no obvious value for
what to fill in for all of the existing users' ages, but better to have
that discussion at development time than to spend weeks or months
dealing with the fallout of invalid users in the system.

\* \* \*

I hope I've laid out a case for using non-null constraints for all
required database fields for great justice. In the next post, I'll show
the proper way to add non-null columns to existing tables.
