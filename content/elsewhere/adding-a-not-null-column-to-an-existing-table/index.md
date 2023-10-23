---
title: "Adding a NOT NULL Column to an Existing Table"
date: 2014-09-30T00:00:00+00:00
draft: false
needs_review: true
canonical_url: https://www.viget.com/articles/adding-a-not-null-column-to-an-existing-table/
---

*Despite some exciting advances in the field, like
[Node](http://nodejs.org/), [Redis](http://redis.io/), and
[Go](https://golang.org/), a well-structured relational database fronted
by a Rails or Sinatra (or Django, etc.) app is still one of the most
effective toolsets for building things for the web. In the coming weeks,
I'll be publishing a series of posts about how to be sure that you're
taking advantage of all your RDBMS has to offer.*

ASSUMING MY [LAST
POST](https://viget.com/extend/required-fields-should-be-marked-not-null)
CONVINCED YOU of the *why* of marking required fields `NOT NULL`, the
next question is *how*. When creating a brand new table, it's
straightforward enough:

    CREATE TABLE employees (
     id integer NOT NULL,
     name character varying(255) NOT NULL,
     created_at timestamp without time zone,
     ...
    );

When adding a column to an existing table, things get dicier. If there
are already rows in the table, what should the database do when
confronted with a new column that 1) cannot be null and 2) has no
default value? Ideally, the database would allow you to add the column
if there is no existing data, and throw an error if there is. As we'll
see, depending on your choice of database platform, this isn't always
the case.

## A Naïve Approach {#anaïveapproach}

Let's go ahead and add a required `age` column to our employees table,
and let's assume I've laid my case out well enough that you're going to
require it to be non-null. To add our column, we create a migration like
so:

    class AddAgeToEmployees < ActiveRecord::Migration
     def change
     add_column :employees, :age, :integer, null: false
     end
    end 

The desired behavior on running this migration would be for it to run
cleanly if there are no employees in the system, and to fail if there
are any. Let's try it out, first in Postgres, with no employees:

    == AddAgeToEmployees: migrating ==============================================
    -- add_column(:employees, :age, :integer, {:null=>false})
     -> 0.0006s
    == AddAgeToEmployees: migrated (0.0007s) =====================================

Bingo. Now, with employees:

    == AddAgeToEmployees: migrating ==============================================
    -- add_column(:employees, :age, :integer, {:null=>false})
    rake aborted!
    StandardError: An error has occurred, this and all later migrations canceled:

    PG::NotNullViolation: ERROR: column "age" contains null values

Exactly as we'd expect. Now let's try SQLite, without data:

    == AddAgeToEmployees: migrating ==============================================
    -- add_column(:employees, :age, :integer, {:null=>false})
    rake aborted!
    StandardError: An error has occurred, this and all later migrations canceled:

    SQLite3::SQLException: Cannot add a NOT NULL column with default value NULL: ALTER TABLE "employees" ADD "age" integer NOT NULL

Regardless of whether or not there are existing rows in the table,
SQLite won't let you add `NOT NULL` columns without default values.
Super strange. More information on this ... *quirk* ... is available on
this [StackOverflow
thread](http://stackoverflow.com/questions/3170634/how-to-solve-cannot-add-a-not-null-column-with-default-value-null-in-sqlite3).

Finally, our old friend MySQL. Without data:

    == AddAgeToEmployees: migrating ==============================================
    -- add_column(:employees, :age, :integer, {:null=>false})
     -> 0.0217s
    == AddAgeToEmployees: migrated (0.0217s) =====================================

Looks good. Now, with data:

    == AddAgeToEmployees: migrating ==============================================
    -- add_column(:employees, :age, :integer, {:null=>false})
     -> 0.0190s
    == AddAgeToEmployees: migrated (0.0191s) =====================================

It ... worked? Can you guess what our existing user's age is?

    > be rails runner "p Employee.first"
    #<Employee id: 1, name: "David", created_at: "2014-07-09 00:41:08", updated_at: "2014-07-09 00:41:08", age: 0>

Zero. Turns out that MySQL has a concept of an [*implicit
default*](http://stackoverflow.com/questions/22868345/mysql-add-a-not-null-column/22868473#22868473),
which is used to populate existing rows when a default is not supplied.
Neat, but exactly the opposite of what we want in this instance.

### A Better Approach {#abetterapproach}

What's the solution to this problem? Should we just always use Postgres?

[Yes.](https://www.youtube.com/watch?v=bXpsFGflT7U)

But if that's not an option (say your client's support contract only
covers MySQL), there's still a way to write your migrations such that
Postgres, SQLite, and MySQL all behave in the same correct way when
adding `NOT NULL` columns to existing tables: add the column first, then
add the constraint. Your migration would become:

    class AddAgeToEmployees < ActiveRecord::Migration
     def up
     add_column :employees, :age, :integer
     change_column_null :employees, :age, false
     end

     def down
     remove_column :employees, :age, :integer
     end
    end

Postgres behaves exactly the same as before. SQLite, on the other hand,
shows remarkable improvement. Without data:

    == AddAgeToEmployees: migrating ==============================================
    -- add_column(:employees, :age, :integer)
     -> 0.0024s
    -- change_column_null(:employees, :age, false)
     -> 0.0032s
    == AddAgeToEmployees: migrated (0.0057s) =====================================

Success -- the new column is added with the null constraint. And with
data:

    == AddAgeToEmployees: migrating ==============================================
    -- add_column(:employees, :age, :integer)
     -> 0.0024s
    -- change_column_null(:employees, :age, false)
    rake aborted!
    StandardError: An error has occurred, this and all later migrations canceled:

    SQLite3::ConstraintException: employees.age may not be NULL

Perfect! And how about MySQL? Without data:

    == AddAgeToEmployees: migrating ==============================================
    -- add_column(:employees, :age, :integer)
     -> 0.0145s
    -- change_column_null(:employees, :age, false)
     -> 0.0176s
    == AddAgeToEmployees: migrated (0.0323s) =====================================

And with:

    == AddAgeToEmployees: migrating ==============================================
    -- add_column(:employees, :age, :integer)
     -> 0.0142s
    -- change_column_null(:employees, :age, false)
    rake aborted!
    StandardError: An error has occurred, all later migrations canceled:

    Mysql2::Error: Invalid use of NULL value: ALTER TABLE `employees` CHANGE `age` `age` int(11) NOT NULL

BOOM. [Flawless victory.](https://www.youtube.com/watch?v=kXuCvIbY1v4)

\* \* \*

To summarize: never use `add_column` with `null: false`. Instead, add
the column and then use `change_column_null` to set the constraint for
correct behavior regardless of database platform. In a follow-up post,
I'll focus on what to do when you don't want to simply error out if
there is existing data, but rather migrate it into a good state before
setting `NOT NULL`.
