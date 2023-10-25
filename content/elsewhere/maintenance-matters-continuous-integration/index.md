---
title: "Maintenance Matters: Continuous Integration"
date: 2022-08-26T00:00:00+00:00
draft: false
canonical_url: https://www.viget.com/articles/maintenance-matters-continuous-integration/
---

*This article is part of a series focusing on how developers can center
and streamline software maintenance. The other articles in the
Maintenance Matters series are: [Code
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

As Annie said in her [intro
post](https://www.viget.com/articles/maintenance-matters/):

> There are many factors that go into a successful project, but in this
> series, we're focusing on the small things that developers usually
> have control over. Over the next few months, we'll be expanding on
> many of these in separate articles.

Today I'd like to talk to you about **Continuous Integration**, as I
feel strongly that it's something no software effort should be without.
Now, before we start, I should clarify:
[Wikipedia](https://en.wikipedia.org/wiki/Continuous_integration)
defines Continuous Integration as "the practice of merging all
developers' working copies to a shared mainline several times a day."
Maybe this was a revolutionary idea in 1991? I don't know, I was in
second grade. Nowadays, at least at Viget, the whole team frequently
merging their work into a common branch is the noncontroversial default.

For the purposes of this Maintenance Matters article, I'll be focused on
this aspect of CI:

> In addition to automated unit tests, organisations using CI typically
> use a build server to implement continuous processes of applying
> quality control in general -- small pieces of effort, applied
> frequently.

If you're not familiar with the concept, it's pretty simple: a typical
Viget dev project includes one or more [GitHub Action
Workflows](https://docs.github.com/en/actions/using-workflows/workflow-syntax-for-github-actions)
that define a series of tasks that should run every time code is pushed
to the central repository. At a minimum, the workflow checks out the
code, installs the necessary dependencies, and runs the automated test
suite. In most cases, pushes to the `main` branch will trigger automatic
deployment to an internal QA environment (a process known as [continuous
deployment](https://en.wikipedia.org/wiki/Continuous_deployment)). If
any step fails (e.g. the tests don't pass or a dependency can't be
installed), the process aborts and the team gets notified.

CI is a very tactical, concrete thing you do, but more than that, it's a
mindset -- it's your team's values made concrete. It's one thing to say
"all projects must have 100% code coverage"; it's another thing entirely
to move your deploys into a CI task that only runs after the coverage
check, so that nothing can go live until it's fully tested. Continuous
Integration is code that improves the way you write code, and a
commitment to continuous improvement.

So what can you do with Continuous Integration? I've mentioned the two
primary tasks (running tests and automated deployment), but that's
really just the tip of the iceberg. You can also:

-   Check code coverage
-   Run linters (like `rubocop`, `eslint`, or `prettier`) to enforce
    coding standards
-   Scan for security issues with your dependencies
-   Tag releases in Sentry (or your error tracking tool of choice)
-   Deploy feature branches to
    [Vercel](https://vercel.com/)/[Netlify](https://www.netlify.com/)/[Fly.io](https://fly.io/)
    for easy previews during code review
-   Build Docker images and push them to a registry
-   Create release artifacts

Really, anything a computer can do, a CI runner can do:

-   Send messages to Slack
-   Spin up new servers as part of a blue/green deployment strategy
-   Run your seed script, assert that every model has a valid record
-   Grep your codebase for git conflict artifacts
-   Assert that all images have been properly optimized

That's not to say you can't overdo it -- you can. It can take a long
time to configure, and workflows can take a long time to run as
codebases grow. It can cost a lot if you're running a lot of builds. It
can be error-prone, with issues that only occur in CI. And it can be
interpersonally fraught -- as I said, it's your team's values made
concrete, and sometimes getting that alignment is the hardest part.

Nevertheless, I consider some version of CI to be mandatory for any
software project. It should be part of initial project setup -- get
aligned with your team on what standards you want to enforce, choose
your CI tool, and get it configured ASAP, ideally before development
begins in earnest. It's much easier to stick with established, codified
standards than to come back and try to add them later.

As mentioned previously, we're big fans of GitHub Actions and its
seamless integration with the rest of our workflow. [Here's a good guide
for getting started](https://docs.github.com/en/actions/quickstart).
We've also used and enjoyed [CircleCI](https://circleci.com/), [GitLab
CI/CD](https://docs.gitlab.com/ee/ci/), and
[Jenkins](https://www.jenkins.io/). Ultimately, the tool doesn't matter
all that much provided it can reliably trigger jobs on push and report
failures, so find the one that works best for your team.

That's the what, why, and how of Continuous Integration. Of course, all
this is precipitated by having a high-functioning team. And there's no
[GitHub Action for
**that**](https://github.com/marketplace?type=actions&query=good+development+team),
unfortunately.

*The next article in this series is [Maintenance Matters: Code
Coverage.](https://www.viget.com/articles/maintenance-matters-code-coverage/)*
