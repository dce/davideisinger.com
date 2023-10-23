---
title: "Simple, Secure File Transmission"
date: 2013-08-29T00:00:00+00:00
draft: false
needs_review: true
canonical_url: https://www.viget.com/articles/simple-secure-file-transmission/
---

Often I need to send a file containing sensitive information, like a
database dump or a digital certificate, to a client or fellow developer.
It's difficult to know the correct level of paranoia to exhibit in
situations like these. Obviously, nobody's sitting in front of a
computer in a dark room, just *waiting* for me to leak the SSL
certificate for the staging Solr EC2 box. At the same time, I know there
are many people with access to my email, my Dropbox, my Basecamp posts,
and it would be irresponsible of me to rely on their collective good
faith to keep this information secure.

I've settled on a simple solution that doesn't inconvenience the sender
or receiver too terribly much (assuming they're both on modern,
Unix-compatible machines) while making things considerably more
difficult for any would-be eavesdroppers. Suppose I want to send an AWS
PEM certificate to [Chris](https://viget.com/about/team/cjones),
disregarding the fact that he's sitting maybe four feet from me right
now. Here's what I'd do:

### Step 1: Encrypt with OpenSSL

I have a short shell script, `encrypt.sh`, that lives in my `~/.bin`
directory:

    #!/bin/sh

    openssl aes-256-cbc -a -salt -pass "pass:$2" -in $1 -out $1.enc

    echo "openssl aes-256-cbc -d -a -pass \"pass:XXX\" -in $1.enc -out $1"

This script takes two arguments: the file you want to encrypt and a
password (or, preferably, a [passphrase](https://xkcd.com/936/)). To
encrypt the certificate, I'd run:

    encrypt.sh production.pem 
    "I can get you a toe by 3 o'clock this afternoon."

The script creates an encrypted file, `production.pem.enc`, and outputs
instructions for decrypting it, but with the password blanked out.

### Step 2: Send the encryped file

From here, I'd move the encrypted file to my Dropbox public folder and
send Chris the generated link, as well as the output of `encrypt.sh`,
over IM:

![](http://i.imgur.com/lSEsz5z.jpg)

Once he acknowledges that he's received the file, I immediately delete
it.

### Step 3: Send the password (via another channel)

Now I need to send Chris the password. Here's what I **don't** do: send
it to him over the same channel that I used to send the file itself.
Instead, I pull out my phone and send it to him as a text message:

![](http://i.imgur.com/pQHZlkO.jpg)

Now Chris has the file, instructions to decrypt it, and the passphrase,
so he's good to go. An attacker, meanwhile, would need access to both
his Google chat and iOS messages, or at least a sweet [\$5
wrench](http://xkcd.com/538/). (Friday is two-for-one XKCD day, in case
you missed the sign out front.)

------------------------------------------------------------------------

So that's what I've been doing when I have to send private files across
the network. I'm sure a security expert could find a hundred ways that
it's insufficient, but I hope said strawman expert would agree that this
is a much better approach than sending this information in the clear.
I'm curious what others do in these types of situations -- let me know
in the comments below.
