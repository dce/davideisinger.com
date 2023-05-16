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
* Create stub objects to stand in for network calls
  * Use [JSON Schema][1] to ensure stub stays in sync
* Coverage
  * We shoot for 100% in SimpleCov (So all the Ruby is tested)
  * Some consider this too high or too burdensome -- I don't
  * Occasionally you have to ignore some code -- e.g. something that only runs in production
* Flaky tests are bad
  * They eat up a lot of development time (esp. as build times increase)
  * Try to stay on top of them and squash them as they arise
  * Some frameworks have `retry` options/libraries that can help (bandage not cure)
  * In general, though, flaky tests suck and generally indicate lack of quality with either your code or your tools

[1]: https://json-schema.org/

{{<thumbnail notes "400x" />}}
