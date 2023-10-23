---
title: "Simple Commit Linting for Issue Number in GitHub Actions"
date: 2023-04-28T00:00:00+00:00
draft: false
needs_review: true
canonical_url: https://www.viget.com/articles/simple-commit-linting-for-issue-number-in-github-actions/
---

I don\'t believe there is **a** right way to do software; I think teams
can be effective (or ineffective!) in a lot of different ways using all
sorts of methodologies and technologies. But one hill upon which I will
die is this: referencing tickets in commit messages pays enormous
dividends over the long haul and you should always do it. As someone who
regularly commits code to apps created in the Obama era, nothing warms
my heart like running
[`:Git blame`](https://github.com/tpope/vim-fugitive#fugitivevim) on
some confusing code and seeing a reference to a GitHub Issue where I can
get the necessary context. And, conversely, nothing sparks nerd rage
like `fix bug` or `PR feedback` or, heaven forbid, `oops`.

In a recent [project
retrospective](https://www.viget.com/articles/get-the-most-out-of-your-internal-retrospectives/),
the team identified that we weren\'t being as consistent with this as
we\'d like, and decided to take action. I figured some sort of commit
linting would be a good candidate for [continuous
integration](https://www.viget.com/articles/maintenance-matters-continuous-integration/)
--- when a team member pushes a branch up to GitHub, check the commits
and make sure they include a reference to a ticket.

I looked into [commitlint](https://commitlint.js.org/), but I found it a
lot more opinionated than I am --- I really just want to make sure
commits begin with either `[#XXX]` (an issue number) or `[n/a]` --- and
rather difficult to reconfigure. After struggling with it for a few
hours, I decided to just DIY it with a simple inline script. If you just
want something you can drop into a GitHub Actions YAML file to lint your
commits, here it is (but stick around and I\'ll break it down and then
show how to do it in a few other languages):

``` yaml
 steps:
   - name: Checkout code
     uses: actions/checkout@v3
     with:
       fetch-depth: 0

  - name: Set up ruby 3.2.1
    uses: ruby/setup-ruby@v1
    with:
      ruby-version: 3.2.1

  - name: Lint commits
    run: |
      git log --format=format:%s HEAD ^origin/main | ruby -e '
        $stdin.each_line do |msg|
          next if /^\[(#\d+|n\/a)\]/.match?(msg)
          warn %(Commits must begin with [#XXX] or [n/a] (#{msg.strip}))
          exit 1
        end
      '
```

A few notes:

-   That `fetch-depth: 0` is essential in order to be able to compare
    the branch being built with `main` (or whatever you call your
    primary development branch) --- by default, your Action only knows
    about the current branch.
-   `git log --format=format:%s HEAD ^origin/main` is going to give you
    the first line of every commit that\'s in the source branch but not
    in `main`; those are the commits we want to lint.
-   With that list of commits, we loop through each message and compare
    it with the regular expression `/^\[(#\d+|n\/a)\]/`, i.e. does this
    message begin with either `[#XXX]` (where `X` are digits) or
    `[n/a]`?
-   If any message does **not** match, print an error out to standard
    error (that\'s `warn`) and exit with a non-zero status (so that the
    GitHub Action fails).

If you want to try this out locally (or perhaps modify the script to
validate messages in a different way), here\'s a `docker run` command
you can use:

``` bash
echo '[#123] Message 1
[n/a] Message 2
[#122] Message 3' | docker run --rm -i ruby:3.2.1 ruby -e '
  $stdin.each_line do |msg|
    next if /^\[(#\d+|n\/a)\]/.match?(msg)
    warn %(Commits must begin with [#XXX] or [n/a] (#{msg.strip}))
    exit 1
  end
'
```

Note that running this command should output nothing since these are all
valid commit messages; modify one of the messages if you want to see the
failure state.

[]{#other-languages}

## Other Languages [\#](#other-languages "Direct link to Other Languages"){.anchor aria-label="Direct link to Other Languages"}

Since there\'s a very real possibility you might not otherwise install
Ruby in your GitHub Actions, and because I weirdly enjoy writing the
same code in a bunch of different languages, here are scripts for
several of Viget\'s other favorites:

[]{#javaScript}

### JavaScript [\#](#javaScript "Direct link to JavaScript"){.anchor aria-label="Direct link to JavaScript"}

``` bash
git log --format=format:%s HEAD ^origin/main | node -e "
  let msgs = require('fs').readFileSync(0).toString().trim().split('\n');
  for (let msg of msgs) {
    if (msg.match(/^\[(#\d+|n\/a)\]/)) { continue; }
    process.stderr.write('Commits must begin with [#XXX] or [n/a] (' + msg + ')');
    process.exit(1);
  }
"
```

To test:

``` bash
echo '[#123] Message 1
[n/a] Message 2
[#122] Message 3' | docker run --rm -i node:18.15.0 node -e "
  let msgs = require('fs').readFileSync(0).toString().trim().split('\n');
  for (let msg of msgs) {
    if (msg.match(/^\[(#\d+|n\/a)\]/)) { continue; }
    process.stderr.write('Commits must begin with [#XXX] or [n/a] (' + msg + ')');
    process.exit(1);
  }
"
```

[]{#php}

### PHP [\#](#php "Direct link to PHP"){.anchor aria-label="Direct link to PHP"}

``` bash
git log --format=format:%s HEAD ^origin/main | php -r '
  while ($msg = fgets(STDIN)) {
    if (preg_match("/^\[(#\d+|n\/a)\]/", $msg)) { continue; }
    fwrite(STDERR, "Commits must begin with #[XXX] or [n/a] (" . trim($msg) . ")\n");
    exit(1);
  }
'
```

To test:

``` bash
echo '[#123] Message 1
[n/a] Message 2
[#122] Message 3' | docker run --rm -i php:8.2.4 php -r '
  while ($msg = fgets(STDIN)) {
    if (preg_match("/^\[(#\d+|n\/a)\]/", $msg)) { continue; }
    fwrite(STDERR, "Commits must begin with #[XXX] or [n/a] (" . trim($msg) . ")\n");
    exit(1);
  }
'
```

[]{#python}

### Python [\#](#python "Direct link to Python"){.anchor aria-label="Direct link to Python"}

``` bash
git log --format=format:%s HEAD ^origin/main | python -c '
import sys
import re
for msg in sys.stdin:
    if re.match(r"^\[(#\d+|n\/a)\]", msg):
        continue
    print("Commits must begin with #[xxx] or [n/a] (%s)" % msg.strip(), file=sys.stderr)
    sys.exit(1)
'
```

To test:

``` bash
echo '[#123] Message 1
[n/a] Message 2
[#122] Message 3' | docker run --rm -i python:3.11.3 python -c '
import sys
import re
for msg in sys.stdin:
    if re.match(r"^\[(#\d+|n\/a)\]", msg):
        continue
    print("Commits must begin with #[xxx] or [n/a] (%s)" % msg.strip(), file=sys.stderr)
    sys.exit(1)
'
```

------------------------------------------------------------------------

So there you have it: simple GitHub Actions commit linting in most of
Viget\'s favorite languages (try as I might, I could not figure out how
to do this in [Elixir](https://elixir-lang.org/), at least not in a
concise way). As I said up front, writing good tickets and then
referencing them in commit messages so that they can easily be surfaced
with `git blame` pays **huge** dividends over the life of a codebase. If
you\'re not already in the habit of doing this, well, the best time to
start was `Initial commit`, but the second best time is today.
