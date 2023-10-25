---
title: "Let’s Make a Hash Chain in SQLite"
date: 2021-06-30T00:00:00+00:00
draft: false
canonical_url: https://www.viget.com/articles/lets-make-a-hash-chain-in-sqlite/
---

I'm not much of a cryptocurrency enthusiast, but there are some neat
ideas in these protocols that I wanted to explore further. Based on my
absolute layperson's understanding, the "crypto" in
"cryptocurrency" describes three things:

1.  Some public key/private key stuff to grant access to funds at an
    address;
2.  For certain protocols (e.g. Bitcoin), the cryptographic
    puzzles[^1] that miners
    have to solve in order to add new blocks to the ledger; and
3.  The use of hashed signatures to ensure data integrity.

Of those three uses, the first two (asymmetric cryptography and
proof-of-work) aren't that interesting to me, at least from a technical
perspective. The third concept, though --- using cryptography to make
data verifiable and tamper-resistant --- that's pretty cool, and
something I wanted to dig into. I decided to build a little
proof-of-concept using [SQLite](https://www.sqlite.org/index.html), a
"small, fast, self-contained, high-reliability, full-featured, SQL
database engine."

A couple notes before we dive in: these concepts aren't unique to the
blockchain; Wikipedia has good explanations of [cryptographic hash
functions](https://en.wikipedia.org/wiki/Cryptographic_hash_function),
[Merkle trees](https://en.wikipedia.org/wiki/Merkle_tree), and [hash
chains](https://en.wikipedia.org/wiki/Hash_chain) if any of this piques
your curiosity. This stuff is also [at the core of
git](https://initialcommit.com/blog/git-bitcoin-merkle-tree), which is
really pretty neat.

## Onto the code

Implementing a rudimentary hash chain in SQL is pretty simple. Here's
my approach, which uses "bookmarks" as an arbitrary record type.

```sql
PRAGMA foreign_keys = ON;
SELECT load_extension("./sha1");

CREATE TABLE bookmarks (
  id INTEGER PRIMARY KEY,
  signature TEXT NOT NULL UNIQUE
    CHECK(signature = sha1(url || COALESCE(parent, ""))),
  parent TEXT,
  url TEXT NOT NULL UNIQUE,
  FOREIGN KEY(parent) REFERENCES bookmarks(signature)
);

CREATE UNIQUE INDEX parent_unique ON bookmarks (
  ifnull(parent, "")
);
```

This code is available on
[GitHub](https://github.com/dce/sqlite-hash-chain) in case you want to
try this out on your own. Let's break it down a little bit.

-   First, we enable foreign key constraints, which aren't on by
    default
-   Then we pull in SQLite's [`sha1`
    function](https://www.i-programmer.info/news/84-database/10527-sqlite-317-adds-sha1-extension.html),
    which implements a common hashing algorithm
-   Then we define our table
    -   `id` isn't mandatory but makes it easier to grab the last entry
    -   `signature` is the SHA1 hash of the bookmark URL and parent
        entry's signature; it uses a `CHECK` constraint to ensure this
        is guaranteed to be true
    -   `parent` is the `signature` of the previous entry in the chain
        (notice that it's allowed to be null)
    -   `url` is the data we want to ensure is immutable (though as
        we'll see later, it's not truly immutable since we can still
        do cascading updates)
-   We set a foreign key constraint that `parent` refers to another
    row's `signature` unless it's null
-   Then we create a unique index on `parent` that covers the `NULL`
    case, since our very first bookmark won't have a parent, but no
    other row should be allowed to have a null parent, and no two rows
    should be able to have the same parent

Next, let's insert some data:

```sql
INSERT INTO bookmarks (url, signature) VALUES ("google", sha1("google"));

WITH parent AS (SELECT signature FROM bookmarks ORDER BY id DESC LIMIT 1)
INSERT INTO bookmarks (url, parent, signature) VALUES (
  "yahoo", (SELECT signature FROM parent), sha1("yahoo" || (SELECT signature FROM parent))
);

WITH parent AS (SELECT signature FROM bookmarks ORDER BY id DESC LIMIT 1)
INSERT INTO bookmarks (url, parent, signature) VALUES (
  "bing", (SELECT signature FROM parent), sha1("bing" || (SELECT signature FROM parent))
);

WITH parent AS (SELECT signature FROM bookmarks ORDER BY id DESC LIMIT 1)
INSERT INTO bookmarks (url, parent, signature) VALUES (
  "duckduckgo", (SELECT signature FROM parent), sha1("duckduckgo" || (SELECT signature FROM parent))
);
```

OK! Let's fire up `sqlite3` and then `.read` this file. Here's the
result:

```
sqlite> SELECT * FROM bookmarks;
+----+------------------------------------------+------------------------------------------+------------+
| id |                signature                 |                  parent                  |    url     |
+----+------------------------------------------+------------------------------------------+------------+
| 1  | 759730a97e4373f3a0ee12805db065e3a4a649a5 |                                          | google     |
| 2  | 64633167b8e44cb833fbfa349731d8a68e942ebc | 759730a97e4373f3a0ee12805db065e3a4a649a5 | yahoo      |
| 3  | ce3df1337879e85bc488d4cae129719cc46cad04 | 64633167b8e44cb833fbfa349731d8a68e942ebc | bing       |
| 4  | 675570ac126d492e449ebaede091e2b7dad7d515 | ce3df1337879e85bc488d4cae129719cc46cad04 | duckduckgo |
+----+------------------------------------------+------------------------------------------+------------+
```

This has some cool properties. I can't delete an entry in the chain:

```
sqlite> DELETE FROM bookmarks WHERE id = 3;
Error: FOREIGN KEY constraint failed
```

I can't change a URL:

```
sqlite> UPDATE bookmarks SET url = "altavista" WHERE id = 3;
Error: CHECK constraint failed: signature = sha1(url || parent)
```

I can't re-sign an entry:

```
sqlite> UPDATE bookmarks SET url = "altavista", signature = sha1("altavista" || parent) WHERE id = 3;
Error: FOREIGN KEY constraint failed
```

I **can**, however, update the last entry in the chain:

```
sqlite> UPDATE bookmarks SET url = "altavista", signature = sha1("altavista" || parent) WHERE id = 4;
sqlite> SELECT * FROM bookmarks;
+----+------------------------------------------+------------------------------------------+-----------+
| id |                signature                 |                  parent                  |    url    |
+----+------------------------------------------+------------------------------------------+-----------+
| 1  | 759730a97e4373f3a0ee12805db065e3a4a649a5 |                                          | google    |
| 2  | 64633167b8e44cb833fbfa349731d8a68e942ebc | 759730a97e4373f3a0ee12805db065e3a4a649a5 | yahoo     |
| 3  | ce3df1337879e85bc488d4cae129719cc46cad04 | 64633167b8e44cb833fbfa349731d8a68e942ebc | bing      |
| 4  | b583a025b5a43727978c169fe99f5422039194ea | ce3df1337879e85bc488d4cae129719cc46cad04 | altavista |
+----+------------------------------------------+------------------------------------------+-----------+
```

This is because a row isn't really "locked in" until it's pointed to
by another row. It's worth pointing out that an actual blockchain would
use a [consensus
mechanism](https://www.investopedia.com/terms/c/consensus-mechanism-cryptocurrency.asp)
to prevent any updates like this, but that's way beyond the scope of
what we're doing here.

## Cascading updates

Given that we can change the last row, it's possible to update any row
in the ledger provided you 1) also re-sign all of its children and 2) do
it all in a single pass. Here's how you'd update row 2 to
"askjeeves" with a [`RECURSIVE`
query](https://www.sqlite.org/lang_with.html#recursive_common_table_expressions)
(and sorry I know this is a little hairy):

```sql
WITH RECURSIVE
  t1(url, parent, old_signature, signature) AS (
    SELECT "askjeeves", parent, signature, sha1("askjeeves" || COALESCE(parent, ""))
    FROM bookmarks WHERE id = 2
    UNION
    SELECT t2.url, t1.signature, t2.signature, sha1(t2.url || t1.signature)
    FROM bookmarks AS t2, t1 WHERE t2.parent = t1.old_signature
  )
UPDATE bookmarks
SET url = (SELECT url FROM t1 WHERE t1.old_signature = bookmarks.signature),
    parent = (SELECT parent FROM t1 WHERE t1.old_signature = bookmarks.signature),
    signature = (SELECT signature FROM t1 WHERE t1.old_signature = bookmarks.signature)
WHERE signature IN (SELECT old_signature FROM t1);
```

Here's the result of running this update:

```
+----+------------------------------------------+------------------------------------------+-----------+
| id |                signature                 |                  parent                  |    url    |
+----+------------------------------------------+------------------------------------------+-----------+
| 1  | 759730a97e4373f3a0ee12805db065e3a4a649a5 |                                          | google    |
| 2  | de357e976171e528088843dfa35c1097017b1009 | 759730a97e4373f3a0ee12805db065e3a4a649a5 | askjeeves |
| 3  | 1b69dff11f3e8ffeade0f42521f9e1bd1bd78539 | de357e976171e528088843dfa35c1097017b1009 | bing      |
| 4  | 924660e4f25e2ac8c38ca25bae201ad3a5b6e545 | 1b69dff11f3e8ffeade0f42521f9e1bd1bd78539 | altavista |
+----+------------------------------------------+------------------------------------------+-----------+
```

As you can see, row 2's `url` is updated, and rows 3 and 4 have updated
signatures and parents. Pretty cool, and pretty much the same thing as
what happens when you change a git commit via `rebase` --- all the
successive commits get new SHAs.

---

I'll be honest that I don't have any immediately practical uses for a
cryptographically-signed database table, but I thought it was cool and
helped me understand these concepts a little bit better. Hopefully it
gets your mental wheels spinning a little bit, too. Thanks for reading!

[^1]: [Here's a pretty good explanation of what mining really is](https://asthasr.github.io/posts/how-blockchains-work/), but, in a nutshell, it's running a hashing algorithm over and over again
  with a random salt until a hash is found that begins with a required number of zeroes.
