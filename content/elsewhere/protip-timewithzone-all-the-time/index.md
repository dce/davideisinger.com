---
title: "Protip: TimeWithZone, All The Time"
date: 2008-09-10T00:00:00+00:00
draft: false
canonical_url: https://www.viget.com/articles/protip-timewithzone-all-the-time/
---

If you've ever tried to retrieve a list of ActiveRecord objects based on
their timestamps, you've probably been bitten by the quirky time support
in Rails:

```
>> Goal.create(:description => "Run a mile")
=> #<Goal id: 1, description: "Run a mile", created_at: "2008-09-09 19:32:57", updated_at: "2008-09-09 19:32:57">
>> Goal.find(:all, :conditions => ['created_at < ?', Time.now])
=> []
````

Huh? Checking the logs, we see that the two commands above correspond to
the following queries:

```sql
INSERT INTO "goals" ("updated_at", "description", "created_at") VALUES('2008-09-09 19:32:57', 'Run a mile', '2008-09-09 19:32:57')
SELECT * FROM "goals" WHERE created_at < '2008-09-09 15:33:17'
````

Rails stores `created_at` relative to [Coordinated Universal
Time](https://en.wikipedia.org/wiki/Coordinated_Universal_Time), while
`Time.now` is based on the system clock, running four hours behind. The
solution? ActiveSupport's
[TimeWithZone](http://caboo.se/doc/classes/ActiveSupport/TimeWithZone.html):

```
>> Goal.find(:all, :conditions => ['created_at < ?', Time.zone.now])
=> [#<Goal id: 1, description: "Run a mile", created_at: "2008-09-09 19:32:57", updated_at: "2008-09-09 19:32:57">]
```

**Rule of thumb:** always use TimeWithZone in your Rails projects. Date,
Time and DateTime simply don't play well with ActiveRecord. Instantiate
it with `Time.zone.now` and `Time.zone.local`. To discard the time
element, use `beginning_of_day`.

## BONUS TIP

Since it's a subclass of Time, interpolating a range of TimeWithZone
objects fills in every second between the two times --- not so useful if
you need a date for every day in a month:


```
>> t = Time.zone.now
=> Tue, 09 Sep 2008 14:26:45 EDT -04:00
>> (t..(t + 1.month)).to_a.size [9 minutes later]
=> 2592001
```

Fortunately, the desired behavior is just a monkeypatch away:

```ruby
class ActiveSupport::TimeWithZone
  def succ
    self + 1.day
  end
end

>> (t..(t + 1.month)).to_a.size
=> 31
```

For more information about time zones in Rails, [Geoff
Buesing](http://mad.ly/2008/04/09/rails-21-time-zone-support-an-overview/)
and [Ryan
Daigle](http://ryandaigle.com/articles/2008/1/25/what-s-new-in-edge-rails-easier-timezones)
have good, up-to-date posts.
