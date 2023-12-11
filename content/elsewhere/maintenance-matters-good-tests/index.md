---
title: "Maintenance Matters: Good Tests"
date: 2023-11-29T09:41:18-05:00
draft: false
canonical_url: https://www.viget.com/articles/maintenance-matters-good-tests/
references:
- title: "A year of Rails - macwright.com"
  url: https://macwright.com/2021/02/18/a-year-of-rails.html
  date: 2023-07-03T02:52:03Z
  file: macwright-com-o4dndf.txt
---

*This article is part of a series focusing on how developers can center
and streamline software maintenance. The other articles in the
Maintenance Matters series are: [Continuous
Integration](/elsewhere/maintenance-matters-continuous-integration/),
[Code
Coverage](https://www.viget.com/articles/maintenance-matters-code-coverage/),
[Documentation](https://www.viget.com/articles/maintenance-matters-documentation/),
[Default
Formatting](https://www.viget.com/articles/maintenance-matters-default-formatting/), [Building
Helpful
Logs](https://www.viget.com/articles/maintenance-matters-helpful-logs/),
[Timely
Upgrades](https://www.viget.com/articles/maintenance-matters-timely-upgrades/),
and [Code
Reviews](https://www.viget.com/articles/maintenance-matters-code-reviews/).*

In this latest entry to our [Maintenance
Matters](https://www.viget.com/articles/maintenance-matters/) series, I
want to talk about automated testing. Annie said it well in her intro
post:

> There is a lot to say about testing, but from a maintainer's
> perspective, let's define good tests as tests that prevent
> regressions. Unit tests should have clear expectations and fail when
> behavior changes, so a developer can either update the expectations or
> fix their code. Feature tests should pass when features work and break
> when features break.

This is a topic better suited to a book than a blog post (and indeed
[there are
many](https://bookshop.org/search?keywords=software+testing)), but I do
think there are a few high-level concepts that are important to
internalize in order to build robust, long-lasting software.

My first exposure to automated testing was with Ruby on Rails. Since
then, I've written production software in many different languages, but
nothing matches the Rails testing story. Tom Macwright said it well in
["A year of
Rails"](https://macwright.com/2021/02/18/a-year-of-rails.html):

> Testing fully-server-rendered applications, on the other hand, is
> amazing. A vanilla testing setup with Rails & RSpec can give you fast,
> stable, concise, and actually-useful test coverage. You can actually
> assert for behavior and navigate through an application like a user
> would. These tests are solving a simpler problem - making requests and
> parsing responses, without the need for a full browser or headless
> browser, without multiple kinds of state to track.

Partly, I think Rails testing is so good because it's baked into the
framework: run `rails generate` to create a new model or controller and
the relevant test files are generated automatically. This helped
establish a community focus on testing, which led to a robust
third-party ecosystem around it. Additionally, Ruby is such a flexible
language that automated testing is really the only viable way to ensure
things are working as expected.

This post isn't about Rails testing specifically, but I wanted to be
clear on my perspective before we really dive in. And with that out of
the way, here's what we'll cover:

1.  [Why Test?](#why-test)
2.  [Types of Tests](#types-of-tests)
3.  [Network Calls](#network-calls)
4.  [Flaky Tests](#flaky-tests)
5.  [Slow Tests](#slow-tests)
6.  [App Code vs. Test Code](#app-code-vs-test-code)

------------------------------------------------------------------------

### Why Test?

The single most important reason to make automated testing part of your
development process is that it **gives you confidence to make changes**.
This gets more and more important over time. With a reliable test suite
in place, you can refactor code, change functionality, and make upgrades
with reasonable certainty that you haven't broken anything. Without good
tests ... good luck.

Secondarily, testing:

-   helps during the development process (testable code is correlated
    with well-factored code, and it's a good way to review your work
    before you ship it off);
-   provides a guide to code reviewers; and
-   serves as a kind of documentation (though not a particularly concise
    one, and not as a replacement for proper written docs).

### Types of Tests

I write two main kinds of tests, which I call **unit tests** and
**integration tests**, though my definitions differ slightly from the
original meanings.

-   **Unit tests** call application code directly -- instantiate an
    object, call a method on it, make assertions about the result. I
    don't particularly care what the object under test does in the
    course of doing its work -- calling off to other objects, performing
    I/O, etc. (this is where I differ from the official definition).
-   **Integration tests** test the entire system end-to-end, using a
    framework like [Capybara](https://teamcapybara.github.io/capybara/)
    or [Playwright](https://playwright.dev/). We sometimes refer to
    these as "feature" tests in our codebases.

End-to-end, black-box integration tests are absolutely critical and can
cover most of your application's functionality by themselves. But it
often makes sense to wrap complex logic in a module, test that directly
(this is where [test-driven
development](https://en.wikipedia.org/wiki/Test-driven_development) can
come into play), and then write a simple integration test to ensure that
the module is getting called correctly. I avoid [mocking and
stubbing](https://en.wikipedia.org/wiki/Mock_object) if at all possible
-- again, "tests should pass when features work and break when features
break" -- and really only reach for it when it's the only option to hit
100% [code
coverage](https://www.viget.com/articles/maintenance-matters-code-coverage/).
In all cases, each test case should run against an empty database to
avoid ordering issues.

### Network Calls

One important exception to the "avoid mocking" rule is third-party APIs:
your test suite should be entirely self-contained and shouldn't call out
to outside services. We use
[webmock](https://github.com/bblimke/webmock#real-requests-to-network-can-be-allowed-or-disabled)
in our Ruby apps to block access to the wider web entirely. Some
providers offer mock services that provide API-conformant responses you
can test against
(e.g., [stripe-mock](https://github.com/stripe/stripe-mock)). If that's
not an option, you can use something like
[VCR](https://github.com/vcr/vcr), which stores network responses as
files and returns cached values on subsequent calls. Beware, though: VCR
works impressively in small doses, but you can lose a lot of time
re-recording "cassettes" over time.

Rather than leaning on VCR, I've instead adopted the following approach:

1.  Wrap the API integration into a standalone object/module
2.  Create a second stub module with the same interface for use in tests
3.  Create a [JSON Schema](https://json-schema.org/) that defines the
    acceptable API responses
4.  Use that schema to validate what comes back from your API modules
    (both the real one and the stub)

If ever the responses coming from the real API fail to match the schema,
that indicates that your app and your tests have fallen out of sync, and
you need to update both.

### Flaky Tests

Flaky tests (tests that fail intermittently, or only fail under certain
conditions) are bad. They eat up a lot of development time, especially
as build times increase. It's important to stay on top of them and
squash them as they arise. A single test that fails one time in five
maybe doesn't seem so bad, and it's easier to rerun the build than spend
time tracking it down. But five tests like that mean the build is
failing two-thirds of the time.

Some frameworks have libraries that will retry a failing test a set
number of times before giving up
(e.g., [rspec-retry](https://github.com/NoRedInk/rspec-retry),
[pytest-rerunfailures](https://pypi.org/project/pytest-rerunfailures/)).
These can be helpful, but they're a bandage, not a cure.

### Slow Tests

The speed of your test suite is a much lower priority than the
performance of your application. All else being equal, faster is better,
but a slow test suite that fully exercises your application is vastly
preferable to a fast one that doesn't. Time spent performance-tuning
your tests can generally be better spent on other things. That said, it
*is* worth periodically looking for low-hanging speed-ups -- if
parallelizing your test runs cuts the build time in half, that's worth a
few hours' time investment.

During local development, I'll often run a subset of tests, either by
invoking a test file or specific test case directly, or by using a
wildcard pattern[^1] to run all the relevant tests. Combining that with
running the full suite in
[CI](/elsewhere/maintenance-matters-continuous-integration/)
provides a good balance of flow and rigor. At some point, if your test
suite is getting so slow that it's meaningfully impacting your team's
work, it's probably a sign that your app has gotten too large and needs
to be broken up into multiple discrete services.

### App Code vs. Test Code

Tests are code, but they're not application code, and the way you
approach them should be slightly different. Some (or even a lot of)
repetition is OK; don't be too quick to refactor. Ideally, someone can
get a sense of what a test is doing by looking at a single screen of
code, as opposed to jumping around between early setup, shared examples,
complex factories with side-effects, etc.

I think of a test case sort of like a page in a book. I don't expect to
be able to open any random page in any random book and immediately grasp
the material, but assuming I'm otherwise familiar with the book's
content, I should be able to look at a single page and have a pretty
good sense of what's going on. A book that frequently required me to
jump to multiple other pages to understand a concept would not be a very
good book, and a test that spreads its setup across multiple other files
is not a very good test.

------------------------------------------------------------------------

Automated testing is a (perhaps **the**) critical component of
sustainable software development. It's not a replacement for human
testing, but with a reliable automated test suite in place, your testers
can focus on what's changed and not worry about regressions in other
parts of the system. It really doesn't add much time to the development
process (provided you know what you're doing), and any increase in
velocity you gain by forgoing testing is quickly erased by time spent
fixing bugs.

[^1]: For example, if I'm working on the part of the system that deals with sending email, I'll run all the tests with `mail` in the filename with `rspec spec/{models,features,lib}/**/*mail*`.
