---
title: "Good Tests"
date: 2023-05-12T23:40:19-04:00
draft: false
---

* Most importantly: **give you confidence to make changes**
* You need proper end-to-end testing
  * Set up your data (fresh per test)
  * Visit a page
  * Interact with it
  * Make assertions about the results
* Put complex logic into easily testable objects/functions
* Create stub objects to stand in for network calls
  * Use [JSON Schema][1] to ensure stub stays in sync
* Avoid over-stubbing/mocking
* Coverage
  * We shoot for 100% in SimpleCov (So all the Ruby is tested)
  * Some consider this too high or too burdensome -- I don't
  * Occasionally you have to ignore some code -- e.g. something that only runs in production

[1]: https://json-schema.org/

{{<thumbnail notes "400x" />}}
