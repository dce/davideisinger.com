---
title: "cURL and Your Rails 2 App"
date: 2008-03-28T00:00:00+00:00
draft: false
canonical_url: https://www.viget.com/articles/curl-and-your-rails-2-app/
---

If you're anything like me, you've used
[cURL](https://en.wikipedia.org/wiki/CURL) to download a batch of MP3
files from the web, or to move a TAR file from one remote server to
another. It might come as a surprise, then, that cURL is a full-featured
HTTP client, which makes it perfect for interacting with RESTful web
services like the ones encouraged by Rails 2. To illustrate, let's
create a small Rails app called `tv_show`:

```sh
rails tv_show
cd tv_show
script/generate scaffold character name:string action:string
rake db:migrate
script/server
```

Fire up your web browser and create a few characters. Once you've done
that, open a new terminal window and try the following:

```
curl http://localhost:3000/characters.xml
```

You'll get a nice XML representation of your characters:

```xml
<?xml version"1.0" encoding="UTF-8"?>
<characters type="array">
    <character>
        <id type="integer">1</id>
        <name>George Sr.</name>
        <action>goes to jail</action>
        <created-at type="datetime">2008-03-28T11:01:57-04:00</created-at>
        <updated-at type="datetime">2008-03-28T11:01:57-04:00</updated-at>
    </character>
    <character>
        <id type="integer">2</id>
        <name>Gob</name>
        <action>rides a Segway</action>
        <created-at type="datetime">2008-03-28T11:02:07-04:00</created-at>
        <updated-at type="datetime">2008-03-28T11:02:12-04:00</updated-at>
    </character>
    <character>
        <id type="integer">3</id>
        <name>Tobias</name>
        <action>wears cutoffs</action>
        <created-at type="datetime">2008-03-28T11:02:20-04:00</created-at>
        <updated-at type="datetime">2008-03-28T11:02:20-04:00</updated-at>
    </character>
</characters>
```

You can retrieve the representation of a specific character by
specifying his ID in the URL:

```sh
curl http://localhost:3000/characters/1.xml
```

```xml
<?xml version="1.0" encoding="UTF-8"?>
<character>
    <id type="integer">1</id>
    <name>George Sr.</name>
    <action>goes to jail</action>
    <created-at type="datetime">2008-03-28T11:01:57-04:00</created-at>
    <updated-at type="datetime">2008-03-28T11:01:57-04:00</updated-at>
</character>
```

To create a new character, issue a POST request, use the -X flag to
specify the action, and the -d flag to define the request body:

```sh
curl -X POST -d "character[name]=Lindsay&character[action]=does+nothing" http://localhost:3000/characters.xml
```

Here's where things get interesting: unlike most web browsers, which
only support GET and POST, cURL supports the complete set of HTTP
actions. If we want to update one of our existing characters, we can
issue a PUT request to the URL of that character's representation, like
so:

```sh
curl -X PUT -d "character[action]=works+at+clothing+store" http://localhost:3000/characters/4.xml
```

If we want to delete a character, issue a DELETE request:

```sh
curl -X DELETE http://localhost:3000/characters/1.xml
```

For some more sophisticated uses of REST and Rails, check out
[rest-client](https://rest-client.heroku.com/rdoc/) and
[ActiveResource](http://ryandaigle.com/articles/2006/06/30/whats-new-in-edge-rails-activeresource-is-here).
