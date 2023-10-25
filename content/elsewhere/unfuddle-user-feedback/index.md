---
title: "Unfuddle User Feedback"
date: 2009-06-02T00:00:00+00:00
draft: false
canonical_url: https://www.viget.com/articles/unfuddle-user-feedback/
---

Recently, we wanted a better system for managing feedback from
[SpeakerRate](http://speakerrate.com/) users. While we do receive some
general site suggestions, most of the feedback we get involves discrete
corrections to data (a speaker who has been entered into the system
twice, for example). We started to create a simple admin interface for
managing these requests, when we realized that the ticket tracking
system we use internally, [Unfuddle](http://unfuddle.com/), already has
all the features we need.

Fortunately, Unfuddle has a full-featured
[API](http://unfuddle.com/docs/api), so programatically creating tickets
is simply a matter of adding
[HTTParty](http://railstips.org/2008/7/29/it-s-an-httparty-and-everyone-is-invited)
to our `Feedback` model:

```ruby
class Feedback < ActiveRecord::Base
  include HTTParty

  base_uri "viget.unfuddle.com/projects/#{UNFUDDLE[:project]}"

  validates_presence_of :description

  after_create :post_to_unfuddle,
    :if => proc { Rails.env == "production" }

  def post_to_unfuddle
    self.class.post(
      "/tickets.xml",
      :basic_auth => UNFUDDLE[:auth],
      :query => { :ticket => ticket }
    )
  end

  private

  def ticket
    returning(Hash.new) do |ticket|
      ticket[:summary] = topic
      ticket[:description] = "#{name} (#{email}) - #{created_at}:\n\n#{description}"
      ticket[:milestone_id] = UNFUDDLE[:milestone]
      ticket[:priority] = 3
    end
  end
end
```

We store our Unfuddle configuration in `config/initializers/unfuddle.rb`:

```ruby
UNFUDDLE = {
  :project => 12345,
  :milestone => 12345, # the 'feedback' milestone
  :auth => {
    :username => "username",
    :password => "password"
  }
}
```

Put your user feedback into Unfuddle, and you get all of its features:
email notification, bulk ticket updates, commenting, file attachments,
etc. This technique isn't meant to replace customer-service oriented
software like [Get Satisfaction](http://getsatisfaction.com/) (we're
using both on SpeakerRate), and if you're not already using a ticketing
system to manage your project, this is probably overkill; something like
[Lighthouse](http://lighthouseapp.com/) or [GitHub
Issues](https://github.com/blog/411-github-issue-tracker) would better
suit your needs, and both have APIs if you want to set up a similar
system. But for us here at Viget, who manage all aspects of our projects
through a ticketing system, seeing actionable user feedback in the same
place as the rest of our tasks has been extremely convenient.
