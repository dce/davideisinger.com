---
title: "Shoulda Macros with Blocks"
date: 2009-04-29T00:00:00+00:00
draft: false
needs_review: true
canonical_url: https://www.viget.com/articles/shoulda-macros-with-blocks/
---

When I'm not working on client projects, I keep myself busy
with [SpeakerRate](http://speakerrate.com), a site that lets conference
goers rate the talks they've attended. After a number of similar
suggestions from users, we decided to display the total number of
ratings alongside the averages. Although only talks can be rated,
speakers, events and series also have ratings through their associated
talks. As you can imagine, calculating the total ratings for each of
these required a lot of somewhat repetitive code in the models, and
*very* repetitive code in the associated tests.

Fortunately, since we're using
[Shoulda](http://thoughtbot.com/projects/shoulda/), we were able to DRY
things up considerably with a macro:

``` {#code .ruby}
class Test::Unit::TestCase def self.should_sum_total_ratings klass = model_class context "finding total ratings" do setup do @ratable = Factory(klass.to_s.downcase) end should "have zero total ratings if no rated talks" do assert_equal 0, @ratable.total_ratings end should "have one total rating if one delivery & content rating" do talk = block_given? ? yield(@ratable) : @ratable Factory(:content_rating, :talk => talk) Factory(:delivery_rating, :talk => talk) assert_equal 1, @ratable.reload.total_ratings end end end end 
```

This way, if we're testing a talk, we can just say:

``` {#code .ruby}
class TalkTest < Test::Unit::TestCase context "A Talk" do should_sum_total_ratings end end 
```

But if we're testing something that has a relationship with multiple
talks, our macro accepts a block that serves as a factory to create a
talk with the appropriate relationship. For events, we can do something
like:

``` {#code .ruby}
class EventTest < Test::Unit::TestCase context "An Event" do should_sum_total_ratings do |event| Factory(:talk, :event => event) end end end 
```

I\'m pretty happy with this solution, but having to type "event" three
times still seems a little verbose. If you\'ve got any suggestions for
refactoring, let us know in the comments.

 
