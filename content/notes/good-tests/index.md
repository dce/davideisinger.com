---
title: "Good Tests"
date: 2023-05-12T23:40:19-04:00
draft: false
---

_(Notes for a Viget article I'm putting together)_

* Most importantly: **give you confidence to make changes**
* Focus on two kinds of tests: unit and integration
  * Unit: test your objects/functions directly
  * Integration: simulated browser interactions
  * If you're building an API, you might also have request specs
    * But ideally you're testing the full integration of UI + API
* Unit tests
  * Put complex logic into easily testable objects/functions
  * Avoid over-stubbing/mocking -- what are you even testing
* Integration tests
  * You need proper end-to-end testing
  * Set up your data (fresh per test)
  * Visit a page
  * Interact with it
  * Make assertions about the results
* Third-party/network calls
  * VCR is … OK but can become a maintenance problem
  * Block access to the web
  * Create stub objects to stand in for network calls
  * Use [JSON Schema][1] to ensure stub stays in sync
  * This will lead to more reliable tests and also more robust code
* Coverage
  * We shoot for 100% in SimpleCov (So all the Ruby is tested)
  * Some consider this too high or too burdensome -- I don't
  * If it's 100%, you instantly know if you have any untested code
    * If it's, say, 94%, and you add 100 lines, six of those can be untested -- hope they're perfect!
    * In other words, at less than 100% coverage, you don't know if your new feature is fully covered or not
  * Occasionally you have to ignore some code -- e.g. something that only runs in production
* Flaky tests are bad
  * They eat up a lot of development time (esp. as build times increase)
  * Try to stay on top of them and squash them as they arise
  * Some frameworks have `retry` options/libraries that can help (bandage not cure)
  * In general, though, flaky tests suck and generally indicate lack of quality with either your code or your tools

[1]: https://json-schema.org/

{{<thumbnail notes "400x" />}}
