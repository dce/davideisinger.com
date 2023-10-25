---
title: "Testing Solr and Sunspot (locally and on CircleCI)"
date: 2018-11-27T00:00:00+00:00
draft: false
canonical_url: https://www.viget.com/articles/testing-solr-and-sunspot-locally-and-on-circleci/
---

I don't usually write complex search systems, but when I do, I reach
for [Solr](http://lucene.apache.org/solr/) and the awesome
[Sunspot](http://sunspot.github.io/) gem. I pulled them into a recent
client project, and while Sunspot makes it a breeze to define your
search indicies and queries, its testing philosophy can best be
described as "figure it out yourself, smartypants."

I found a [seven-year old code
snippet](https://dzone.com/articles/install-and-test-solrsunspot) that
got me most of the way, but needed to make some updates to make it
compatible with modern RSpec and account for a delay on Circle between
Solr starting and being available to index documents. Here's the
resulting config, which should live in `spec/support/sunspot.rb`:

```ruby
require 'sunspot/rails/spec_helper'
require 'net/http'

try_server = proc do |uri|
  begin
    response = Net::HTTP.get_response uri
    response.code != "503"
  rescue Errno::ECONNREFUSED
  end
end

start_server = proc do |timeout|
  server = Sunspot::Rails::Server.new
  uri = URI.parse("http://0.0.0.0:#{server.port}/solr/default/update?wt=json")

  try_server[uri] or begin
    server.start
    at_exit { server.stop }

    timeout.times.any? do
      sleep 1
      try_server[uri]
    end
  end
end

original_session = nil # always nil between specs
sunspot_server   = nil # one server shared by all specs

if defined? Spork
  Spork.prefork do
    sunspot_server = start_server[60] if Spork.using_spork?
  end
end

RSpec.configure do |config|
  config.before(:each) do |example|
    if example.metadata[:solr]
      sunspot_server ||= start_server[60] || raise("SOLR connection timeout")
    else
      original_session = Sunspot.session
      Sunspot.session = Sunspot::Rails::StubSessionProxy.new(original_session)
    end
  end

  config.after(:each) do |example|
    if example.metadata[:solr]
      Sunspot.remove_all!
    else
      Sunspot.session = original_session
    end

    original_session = nil
  end
end
```

*(Fork me at
<https://gist.github.com/dce/3a9b5d8623326214f2e510839e2cac26>.)*

With this code in place, pass `solr: true` as RSpec metadata[^1]
to your `describe`, `context`, and `it` blocks to test against a live
Solr instance, and against a stub instance otherwise.

## A couple other Sunspot-related things

While I've got you here, thinking about search, here are a few other
neat tricks to make working with Sunspot and Solr easier.

### Use Foreman to start all the things

Install the [Foreman](http://ddollar.github.io/foreman/) gem and create
a `Procfile` like so:

```
rails: bundle exec rails server -p 3000
webpack: bin/webpack-dev-server
solr: bundle exec rake sunspot:solr:run
```

Then you can boot up all your processes with a simple `foreman start`.

### Configure Sunspot to use the same Solr instance in dev and test

[By
default](https://github.com/sunspot/sunspot/blob/3328212da79178319e98699d408f14513855d3c0/sunspot_rails/lib/generators/sunspot_rails/install/templates/config/sunspot.yml),
Sunspot wants to run two different Solr processes, listening on two
different ports, for the development and test environments. You only
need one instance of Solr running --- it'll handle setting up a
"core" for each environment. Just set the port to the same number in
`config/sunspot.yml` to avoid starting up and shutting down Solr every
time you run your test suite.

### Sunspot doesn't reindex automatically in test mode

Just a little gotcha: typically, Sunspot updates the index after every
update to an indexed model, but not so in test mode. You'll need to run
some combo of `Sunspot.commit` and `[ModelName].reindex` after making
changes that you want to test against.

------------------------------------------------------------------------

That's all I've got. Have a #blessed Tuesday and a happy holiday
season.

[^1]: e.g. `describe "viewing the list of speakers", solr: true do`
