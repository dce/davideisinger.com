---
title: "“Friends” (Undirected Graph Connections) in Rails"
date: 2021-06-09T00:00:00+00:00
draft: false
canonical_url: https://www.viget.com/articles/friends-undirected-graph-connections-in-rails/
featured: true
exclude_music: true
references:
- title: "Storing graphs in the database: SQL meets social network - Inviqa"
  url: https://inviqa.com/blog/storing-graphs-database-sql-meets-social-network
  date: 2024-01-03T21:44:24Z
  file: inviqa-com-kztbkj.txt
---

No, sorry, not THOSE friends. But if you're interested in how to do
some graph stuff in a relational database, SMASH that play button and
read on.

<audio controls src="friends.mp3"></audio>

My current project is a social network of sorts, and includes the
ability for users to connect with one another. I've built this
functionality once or twice before, but I've never come up with a
database implementation I was perfectly happy with. This type of
relationship is perfect for a [graph
database](https://en.wikipedia.org/wiki/Graph_database), but we're
using a relational database and introducing a second data store
wouldn't be worth the overhead.

The most straightforward implementation would involve a join model
(`Connection` or somesuch) with two foreign key columns pointed at the
same table (`users` in our case). When you want to pull back a user's
contacts, you'd have to query against both foreign keys, and then pull
back the opposite key to retrieve the list. Alternately, you could store
connections in both directions and hope that your application code
always inserts the connections in pairs (spoiler: at some point, it
won't).

But what if there was a better way? I stumbled on [this article that
talks through the problem in
depth](https://inviqa.com/blog/storing-graphs-database-sql-meets-social-network),
and it led me down the path of using an SQL view and the
[`UNION`](https://www.postgresqltutorial.com/postgresql-union/)
operator, and the result came together really nicely. Let's walk
through it step-by-step.

First, we'll model the connection between two users:

```ruby
class CreateConnections < ActiveRecord::Migration[6.1]
  def change
    create_table :connections do |t|
      t.references :sender, null: false
      t.references :receiver, null: false

      t.timestamps
    end

    add_foreign_key :connections, :users, column: :sender_id, on_delete: :cascade
    add_foreign_key :connections, :users, column: :receiver_id, on_delete: :cascade

    add_index :connections,
      "(ARRAY[least(sender_id, receiver_id), greatest(sender_id, receiver_id)])",
      unique: true,
      name: :connection_pair_uniq
  end
end
```

I chose to call the foreign keys `sender` and `receiver`, not that I
particularly care who initiated the connection, but it seemed better
than `user_1` and `user_2`. Notice the index, which ensures that a
sender/receiver pair is unique *in both directions* (so if a connection
already exists where Alice is the sender and Bob is the receiver, we
can't insert a connection where the roles are reversed). Apparently
Rails has supported [expression-based
indices](https://bigbinary.com/blog/rails-5-adds-support-for-expression-indexes-for-postgresql)
since version 5. Who knew!

With connections modeled in our database, let's set up the
relationships between user and connection. In `connection.rb`:

```ruby
belongs_to :sender, class_name: "User"
belongs_to :receiver, class_name: "User"
```

In `user.rb`:

```ruby
has_many :sent_connections,
         class_name: "Connection",
         foreign_key: :sender_id
has_many :received_connections,
         class_name: "Connection",
         foreign_key: :receiver_id
```

Next, we'll turn to the
[Scenic](https://github.com/scenic-views/scenic) gem to create a
database view that normalizes sender/receiver into user/contact. Install
the gem, then run `rails generate scenic:model user_contacts`. That'll
create a file called `db/views/user_contacts_v01.sql`, where we'll put
the following:

```sql
SELECT sender_id AS user_id, receiver_id AS contact_id
FROM connections
UNION
SELECT receiver_id AS user_id, sender_id AS contact_id
FROM connections;
```

Basically, we're using the `UNION` operator to merge two queries
together (reversing sender and receiver), then making the result
queryable via a virtual table called `user_contacts`.

Finally, we'll add the contact relationships. In `user_contact.rb`:

```ruby
belongs_to :user
belongs_to :contact, class_name: "User"
```

And in `user.rb`, right below the
`sent_connections`/`received_connections` stuff:

```ruby
has_many :user_contacts
has_many :contacts, through: :user_contacts
```

And that's it! You'll probably want to write some validations and unit
tests but I can't give away all my tricks (or all of my client's
code).

Here's our friendship system in action:

```
[1] pry(main)> u1, u2 = User.first, User.last
=> [#<User id: 1 first_name: "Ross" …>, #<User id: 7 first_name: "Rachel" …>]
[2] pry(main)> u1.sent_connections.create(receiver: u2)
=> #<Connection:0x00007f813cde5f70
 id: 1,
 sender_id: 1,
 receiver_id: 7>
[3] pry(main)> UserContact.all
=> [#<UserContact:0x00007f813ccbefc0 user_id: 7, contact_id: 1>,
 #<UserContact:0x00007f813cca40f8 user_id: 1, contact_id: 7>]
[4] pry(main)> u1.contacts
=> [#<User id: 7 first_name: "Rachel" …>]
[5] pry(main)> u2.contacts
=> [#<User id: 1 first_name: "Ross" …>]
[6] pry(main)> # they're lobsters
[7] pry(main)>
```

So there it is, a simple, easily queryable vertex/edge implementation in
a vanilla Rails app. I hope you have a great day, week, month, and even
year.

------------------------------------------------------------------------

[Network Diagram Vectors by
Vecteezy](https://www.vecteezy.com/free-vector/network-diagram)

[*"I'll Be There for You" (Theme from
Friends)*](https://archive.org/details/tvtunes_31736) © 1995 The
Rembrandts
