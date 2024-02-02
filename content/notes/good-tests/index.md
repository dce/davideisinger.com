---
title: "Good Tests"
date: 2023-05-12T23:40:19-04:00
draft: false
references:
- title: "A year of Rails - macwright.com"
  url: https://macwright.com/2021/02/18/a-year-of-rails.html
  date: 2023-07-03T02:52:03Z
  file: macwright-com-o4dndf.txt
---

_(Notes for a [Viget article][1])_

[1]: /elsewhere/maintenance-matters-good-tests

* Most importantly: **give you confidence to make changes**
  * This gets more and more important over time
* Secondarily:
  * Tells you it works during development
  * Help your code reviewers
  * Serves as a kind of documentation (though not a very concise one)
* Focus on two kinds of tests: unit and integration
  * Unit: test your objects/functions directly
  * Integration: simulated browser interactions
  * If you're building an API, you might also have request specs
    * But ideally you're testing the full integration of UI + API
* Unit tests
  * Put complex logic into easily testable objects/functions
  * This is where [TDD][2] can come into play
  * Avoid over-stubbing/mocking -- what are you even testing
    * It is OK to go down the stack in your unit tests
* Integration tests
  * You need proper end-to-end testing
  * Set up your data (fresh per test)
  * Visit a page
  * Interact with it
  * Make assertions about the results
  * Generally folder per controller, file per action (e.g. `spec/features/posts/create_spec.rb`)
* Coverage
  * We shoot for 100% in SimpleCov (So all the Ruby is tested)
  * Some consider this too high or too burdensome -- I don't
  * If it's 100%, you instantly know if you have any untested code
    * If it's, say, 94%, and you add 100 lines, six of those can be untested -- hope they're perfect!
    * In other words, at less than 100% coverage, you don't know if your new feature is fully covered or not
  * Occasionally you have to ignore some code -- e.g. something that only runs in production
  * It's OK if you're not at 100% right now -- set the threshold to your current level, and increase it as you add tests and new well-tested features
  * [Already covered here][3]
* Third-party/network calls
  * Major libraries often have mock services (e.g. [stripe-mock][4])
  * VCR is … OK but can become a maintenance problem
    * Blocking access to the web is good though -- [webmock][5]
  * A better approach
    * Move your integration code into a module
    * Create a second stub module with the same API
    * Use [JSON Schema][6] to ensure stub stays in sync (i.e. both the real client and the stub client validate against the schema)
    * This will lead to more reliable tests and also more robust code
* Flaky tests are bad
  * They eat up a lot of development time (esp. as build times increase)
  * Try to stay on top of them and squash them as they arise
  * Some frameworks have `retry` options/libraries that can help (bandage not cure)
    * [rspec-retry][7]
  * In general, though, flaky tests suck and generally indicate lack of quality with either your code or your tools
    * So write better code or pick better tools
* Tests are code, but they're not application code
  * And the way you approach them should be slightly different
  * Some (or even a lot of) repetition is OK; don't be too quick to refactor
  * Ideally someone can get a sense of what a test is doing by looking at a single screen of code
  * As opposed to jumping around between early setup, shared examples, complex factories w/ side-effects, etc.
  * Think of it as half programming, half writing

[2]: https://en.wikipedia.org/wiki/Test-driven_development
[3]: https://www.viget.com/articles/maintenance-matters-code-coverage/
[4]: https://github.com/stripe/stripe-mock
[5]: https://github.com/bblimke/webmock#real-requests-to-network-can-be-allowed-or-disabled
[6]: https://json-schema.org/
[7]: https://github.com/NoRedInk/rspec-retry

{{<dither notes.png "400x" />}}
