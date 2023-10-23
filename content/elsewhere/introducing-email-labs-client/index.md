---
title: "Introducing: EmailLabsClient"
date: 2008-07-31T00:00:00+00:00
draft: false
needs_review: true
canonical_url: https://www.viget.com/articles/introducing-email-labs-client/
---

On my latest project, the client is using
[EmailLabs](http://www.emaillabs.com/) to manage their mailing lists. To
simplify interaction with their system, we've created
[EmailLabsClient](https://github.com/vigetlabs/email_labs_client/tree/master),
a small Ruby client for the EmailLabs API. The core of the program is
the `send_request` method:

``` {#code .ruby}
def self.send_request(request_type, activity) xml = Builder::XmlMarkup.new :target => (input = '') xml.instruct! xml.DATASET do xml.SITE_ID SITE_ID yield xml end Net::HTTP.post_form(URI.parse(ENDPOINT), :type => request_type, :activity => activity, :input => input) end 
```

Then you can make API requests like this:

``` {#code .ruby}
def self.subscribe_user(mailing_list, email_address) send_request('record', 'add') do |body| body.MLID mailing_list body.DATA email_address, :type => 'email' end end 
```

If you find yourself needing to work with an EmailLabs mailing list,
check it out. At the very least, you should get a decent idea of how to
interact with their API. It's up on
[GitHub](https://github.com/vigetlabs/email_labs_client/tree/master), so
if you add any functionality, send those patches our way.
