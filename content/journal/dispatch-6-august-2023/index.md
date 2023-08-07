---
title: "Dispatch #6 (August 2023)"
date: 2023-08-06T12:00:00-04:00
draft: false
tags:
- dispatch
references:
- title: "Why I don't use Copilot"
  url: https://inkdroid.org/2023/06/04/copilot/
  date: 2023-08-07T02:20:18Z
  file: inkdroid-org-belior.txt
- title: "Phase change"
  url: https://www.robinsloan.com/lab/phase-change/
  date: 2023-08-07T02:20:18Z
  file: www-robinsloan-com-sbm0vr.txt
- title: "The looming demise of the 10x developer: Why an era of enthusiast programmers is coming to an end"
  url: https://blog.testdouble.com/posts/2023-07-12-the-looming-demise-of-the-10x-developer/
  date: 2023-08-07T02:20:19Z
  file: blog-testdouble-com-krzanb.txt
- title: "Daily notes for 2023-07-17 | Yes, Mike will do."
  url: https://mike.puddingtime.org/posts/2023-07-17-daily-notes/#notes-on-conflict
  date: 2023-08-07T02:20:20Z
  file: mike-puddingtime-org-svf0ua.txt
---

Nice to have a quieter month, though we still managed to spend a weekend at Lake Norman and took Nev on her first camping trip at [Carolina Hemlocks Recreation Area][1]. We also had a nice visit from my folks to celebrate my mom's birthday.

<!--more-->

<div class="image-set">
  {{<thumbnail 05569D5B "400x" />}}
  {{<thumbnail DBCE9DD4 "400x" />}}
</div>

Tech-wise, I switched from Vim to [Helix][2], which I've detailed [over here][3]. I was also able to work through a whole bunch of the [Go track on Exercism][4] -- it's a good way to get a handle on the basics of a language, but doesn't cover using third-party packages, organizing large codebases, etc. To get that kind of experience, I'm going to try my hand at an app for fantasy sports drafts -- take a set of player projections and a scoring formula, and output a UI I can use during a live online draft. I've been doing this with spreadsheets for years, and it's pretty cumbersome. I'm going to use TOML for configuration, SQLite for data persistence, and [Bubble Tea][5] for the UI itself. We'll see how it goes!

I've signed up for the [Bull City Race Fest][6] half-marathon in October. Training starts ... tomorrow. I'm going to try to mix in some better eating habits + cross-training this time.

[1]: https://www.recreation.gov/camping/campgrounds/233954
[2]: https://helix-editor.com/
[3]: /journal/a-month-with-helix
[4]: https://exercism.org/tracks/go
[5]: https://github.com/charmbracelet/bubbletea
[6]: https://capstoneraces.com/bull-city-race-fest/

This month:

* Adventure: spending a weekend at Virginia's Eastern Shore with some childhood friends and a week at the beach with my family
* Project: build a fantasy draft <abbr title="text-based user interface">TUI</abbr> app in Go using [Bubble Tea][5]
* Skill: learn how to organize a larger Go codebase as part of ☝️

Reading:

* Fiction: [_Tress of the Emerald Sea_][7], Brandon Sanderson
* Non-fiction: [_The Creative Programmer_][8], [Wouter Groeneveld][9]

[7]: https://www.brandonsanderson.com/standalones-cosmere/#TRESS
[8]: https://www.manning.com/books/the-creative-programmer
[9]: https://brainbaking.com/

Links:

* [Why I don't use Copilot][10]

  > I enjoy programming because it’s about reasoning, thinking, models, concepts, expression, communication, ethics, reading, learning, making, and process. It’s an art and a practice that is best done with other people.
  >
  > Increasingly I think it’s imperative for programming to be done more slowly, more deliberatively, and as part of more conversations with more people. The furious automation of everything is eating the world.

* [Phase change][11]

  > *What could I do with a universal function — a tool for turning just about any X into just about any Y with plain language instructions?*
  >
  > I don’t pose that question with any sense of wide-eyed expectation; a reason­able answer might be, *eh, nothing much*. Not every­thing in the world depends on the trans­for­ma­tion of symbols. But I think that IS the question, and I think it takes some legit­i­mate work, some strenuous imagination, to push yourself to believe it really will be “just about any X” into “just about any Y”.

* [The looming demise of the 10x developer: Why an era of enthusiast programmers is coming to an end][12]

  > That is to say, I’ve come to believe the era typified by the enthusiast programmer—autodidactic, obsessive, and antisocial—is drawing to a close.

* [Notes on Conflict | Yes, Mike will do.][13]

  > Over time I shifted on the matter a little, but when I look back on it I realize I wasn’t really evolving my attitude toward conflict, I was just evolving my response to its existence, while still believing that being in a state of conflict is a problem. I just got better at keeping my blood pressure low and gritting through it. I think I was looking at conflict as a thing that you have to acknowledge exists, but that you need to get through as quickly as possible, because it’s a bad place to be.

[10]: https://inkdroid.org/2023/06/04/copilot/
[11]: https://www.robinsloan.com/lab/phase-change/
[12]: https://blog.testdouble.com/posts/2023-07-12-the-looming-demise-of-the-10x-developer/
[13]: https://mike.puddingtime.org/posts/2023-07-17-daily-notes/#notes-on-conflict
