---
title: "How (& Why) to Run Autotest on your Mac"
date: 2009-06-19T00:00:00+00:00
draft: false
canonical_url: https://www.viget.com/articles/how-why-to-run-autotest-on-your-mac/
---

If you aren't using Autotest to develop your Ruby application, you're
missing out on effortless continuous testing. If you'd *like* to be
using Autotest, but can't get it running properly, I'll show you how to
set it up.

Autotest is a fantastic way to do TDD/BDD. Here's a rundown of the
benefits from the [project
homepage](http://www.zenspider.com/ZSS/Products/ZenTest/):

-   Improves feedback by running tests continuously.
-   Continually runs tests based on files you've changed.
-   Get feedback as soon as you save. Keeps you in your editor allowing
    you to get stuff done faster.
-   Focuses on running previous failures until you've fixed them.

Like any responsible Ruby citizen, Autotest changes radically every
month or so. A few weeks ago, some enterprising developers released
autotest-mac (now
[autotest-fsevent](http://www.bitcetera.com/en/techblog/2009/05/27/mac-friendly-autotest/)),
which monitors code changes via native OS X system events rather than by
polling the hard drive, increasing battery and disk life and improving
performance. Here's how get Autotest running on your Mac, current as of
this morning:

1.  Install autotest:

    ```
    gem install ZenTest 
    ```

2.  Or, if you've already got an older version installed:

    ```
    gem update ZenTest
    gem cleanup ZenTest 
    ```

3.  Install autotest-rails:

    ```
    gem install autotest-rails 
    ```

4.  Install autotest-fsevent:

    ```
    gem install autotest-fsevent 
    ```

5.  Install autotest-growl:

    ```
    gem install autotest-growl 
    ```

6.  Make a `~/.autotest` file, with the following:

    ```ruby
    require "autotest/growl"
    require "autotest/fsevent" 
    ```

7.  Run `autotest` in your app root.

Autotest is a fundamental part of my development workflow, and well
worth the occasional setup headache; give it a shot and I think you'll
agree. These instructions should be enough to get you up and running,
unless you're reading this more than three weeks after it was published,
in which case all. bets. are. off.
