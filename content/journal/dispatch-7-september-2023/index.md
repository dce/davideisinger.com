---
title: "Dispatch #7 (September 2023)"
date: 2023-09-08T00:00:00-04:00
draft: false
tags:
- dispatch
references:
- title: "FunlandRehoboth"
  url: https://funlandrehoboth.com/
  date: 2023-09-05T03:33:17Z
  file: funlandrehoboth-com-jrkd5r.txt
- title: Storm leaves trail of damage across central NC; Thousands still without power Wednesday | WUNC
  url: https://www.wunc.org/news/2023-08-16/storm-damage-durham-power-outage-closures-north-carolina-816
  date: 2023-08-21T18:18:11Z
  file: www-wunc-org-fstofo.txt
- title: "Radda in Chianti to Siena – Two Nerds | A lifestyle blog"
  url: https://twonerds.net/blog/radda-in-chianti-to-siena
  date: 2023-09-08T20:11:47Z
  file: twonerds-net-pv4a04.txt
- title: "On Tools and the Aesthetics of Work - Cal Newport"
  url: https://calnewport.com/on-tools-and-the-aesthetics-of-work/
  date: 2023-09-09T02:14:13Z
  file: calnewport-com-jtszvi.txt
- title: "Exit, Voice, Loyalty, Neglect: Why People Leave, Stay, or Try to Burn It All Down | The Art of Manliness"
  url: https://www.artofmanliness.com/character/behavior/exit-voice-loyalty-neglect-why-people-leave-stay-or-try-to-burn-it-all-down/
  date: 2023-09-09T02:15:27Z
  file: www-artofmanliness-com-rx8ary.txt
- title: "Digital Notetaking Stack - Notes from your friend Chris"
  url: https://chrisnotes.io/digital-notetaking-stack
  date: 2023-09-09T02:17:52Z
  file: chrisnotes-io-ijc95x.txt
- title: "Why note-taking apps don’t make us smarter - The Verge"
  url: https://www.theverge.com/2023/8/25/23845590/note-taking-apps-ai-chat-distractions-notion-roam-mem-obsidian
  date: 2023-09-09T02:26:18Z
  file: www-theverge-com-mjsr9z.txt
---

We were down at Lake Norman for the long weekend, and as I was pulling up the kayaks this morning, I couldn't help but feel like I was also sort of putting away the summer -- what a summer though. The last few weeks of August were pretty wall-to-wall. I went up to the Eastern Shore in Virginia to spend a long weekend with some old friends. Our rental was right on an inlet off the Chesapeake, and they had a stand-up paddleboard I was able to take out.

<!--more-->

{{<dither IMG_4446.jpeg "782x400" />}}
{{<dither IMG_1602.jpeg "782x400" />}}

The following weekend, we headed up to Rehoboth Beach in Delaware to spend the week with my family. It's different than the North Carolina beaches we're used to as there's a lot to do around the town (boardwalk, parks & playgrounds, [indoor amusement park][1]). We brought our bikes and took a ride on the [Gordons Pond Trail][2], which was rad.

[1]: https://funlandrehoboth.com/
[2]: https://delawaregreenways.org/trail/gordons-pond-trail/

{{<dither IMG_4514.jpeg "782x600" />}}
{{<dither IMG_4575.jpeg "782x600" />}}

We also recorded this little jam featuring my 3.5-year-old niece on the melodica:

<audio controls src="/journal/dispatch-7-september-2023/Nomi.mp3"></audio>

From there, we drove 400 miles to Greensboro, and then onto Lake Norman to spend Labor Day weekend with Claire's family, a relaxing way to cap off an eventful summer.

As one might imagine, this involved a lot of driving, and to pass the hours and miles, I tried something new: listening to audio books. [My local library][3] has a good selection which integrates with the Libby app. I listened to:

* [_The Left Hand of Darkness_][4] by Ursula K. Le Guin. I've enjoyed some of her other stuff and have meant to read this for years. Great story & narration, highly recommended.
* [_With a Mind to Kill_][5] by Anthony Horwitz, a James Bond novel. This one got me through that long drive I mentioned a minute ago. I didn't love this -- the Craig movies did a good job bringing Bond into the modern era, and I felt like the author was trying to be faithful to the Fleming books, which meant treating the female characters poorly. The narrator, Rory Kinner, was great and has a [cool Bond connection][6].

I also started a [low-brow thriller][7] and was surprised that it was the same narrator as _Left Hand_; [I guess this guy records a lot of audio books][8].

[3]: https://durhamcounty.overdrive.com/
[4]: https://durhamcounty.overdrive.com/media/3784285
[5]: https://durhamcounty.overdrive.com/media/6525209
[6]: https://en.wikipedia.org/wiki/Rory_Kinnear
[7]: https://durhamcounty.overdrive.com/media/2152378
[8]: https://en.wikipedia.org/wiki/George_Guidall

We got hit with a [nasty storm][9] in the middle of August. It was wild -- hot, sunny day during my scoot home, then 5 minutes later, hard rain/thunder/80mph winds. We were without power from 4pm until 8pm the following day, and the damage through the city was intense. Phones weren't working very well, traffic lights were out, and even places that had power were cash-only as the credit card systems were down. Fortunately, we have a good set of camping equipment which doubles as disaster preparedness gear, but it made plain the fragility of modern society.

[9]: https://www.wunc.org/news/2023-08-16/storm-damage-durham-power-outage-closures-north-carolina-816

I did a couple projects in Go this month:

{{<dither golong.png "782x" />}}
{{<dither forecast.png "782x" />}}

The first, the fantasy draft <abbr title="text-based user interface">TUI</abbr> app [I mentioned last month][10], came together well and quickly. It was straightforward to set up TOML for configuration, SQLite for data persistence, and [Bubble Tea][11] for the UI. Bubble Tea's super cool -- you pull in your widgets (two in my case, for a table view and a search box), and you can respond to keypresses or let the widgets handle them. As a result, my UI has Vim keybindings without me doing anything, which was super handy during the draft.

I played around with ChatGPT while I was working on it, asking it to make my code more idiomatic. This worked super well, and some of the refactorings were really clever. This seems like a sweet spot of <abbr title="large language models">LLMs</abbr> -- I already had working code and wasn't asking it to solve complex problems, just to make my code look more like the other code it knows about. I also used it to come up with a name for the project, and it came back with `golong`, which is just 🍒.

[10]: /journal/dispatch-6-august-2023/
[11]: https://github.com/charmbracelet/bubbletea

The second was for work -- we needed to crunch some data coming out of [Forecast][12] and the nature of the data (forward-looking, ever-changing) makes it a poor fit for our usual tech. I decided to write a command-line program that reads two <abbr title="comma-separated values">CSVs</abbr> and outputs a third, which we can then import into a Google Sheet. Then I set up an AWS Lambda + API Gateway that serves a very simple web frontend so other folks can run it. This was fun and useful, though it was really low-level programming -- parsing multi-part form bodies, reading and writing basic auth headers, etc. If I were to do something like this again, I'd look for a library that adds additional functionality on top of the basic AWS Lambda request/response stuff. I was able to do some testing with [Testify][13] and learned a lot about structuring slightly larger Go codebases.

[12]: https://www.getharvest.com/forecast
[13]: https://github.com/stretchr/testify

Working with a typed language, a good language server (`gopls`), and an editor that supports it well ([Helix][14]) is a joy -- I can see why people are excited about languages like TypeScript. I'll get `golong` cleaned up and up on GitHub, then write a more detailed post about it.

[14]: /journal/a-month-with-helix/

Final thought: someone (my father-in-law, I think) asked if we thought Nev would remember all these adventures we're having with her, and I said, no, but that's OK and not really the point. Even if she's not yet capable of forming lasting memories, these experiences are forming who she is. We want the first international flight she remembers into adulthood to feel like a familiar thing in the moment. Plus she's such a delight that experiencing new things with her and sharing her with the world is a source of deep joy for us.

### This Month

* Adventure: Italy! Claire and I [did a bike tour through Tuscany][15] in 2017 that was supposed to end at Elba Island, though for various reasons, it did not. Claire has continued to follow the resort on social media, and we decided earlier this summer to finally check it out, Nev in tow. We've been so busy that it's just now coming into focus, but we are getting excited -- [just look at this place][16].
* Project: hanging out with my buddy Ken (pictured up top), who records music as [Carillon][17], is always inspiring. I'd like to get a basic audio recording station set up in my basement and start playing with some acoustic and digital instruments. I'll probably repurpose the door I removed as part of the [closet project][18].
* Skill: just get my non-fiction reading habit back -- the stack to my left here is growing.

[15]: https://twonerds.net/blog/radda-in-chianti-to-siena
[16]: https://www.rosselbalepalme.it/en/glamping-lodge.php
[17]:	https://carillon58.bandcamp.com/album/the-whole-earth
[18]: /journal/dispatch-4-june-2023/

### Reading

* Fiction: [_Forever and a Day_][19], Anthony Horowitz
* Non-fiction: [_The Creative Programmer_][20], [Wouter Groeneveld][21]

[19]: https://bookshop.org/p/books/forever-and-a-day-a-james-bond-novel-anthony-horowitz/7998118
[20]: https://www.manning.com/books/the-creative-programmer
[21]: https://brainbaking.com/

### Links

* [On Tools and the Aesthetics of Work][22]

  > But the Mythic is a useful reminder that the rhythms of our professional lives are not pre-ordained. We craft the world in which we work, even if we don’t realize it.

* [Exit, Voice, Loyalty, Neglect: Why People Leave, Stay, or Try to Burn It All Down][23]

  > Hirschman observed that people who find themselves in diminishing, less-than-ideal circumstances have three options: 1) leave the declining group, company, or relationship (exit), 2) express discontent to improve the situation (voice), or 3) stay in the organization and passively hope things get better (loyalty). 
  >
  > Since the initial publication of Exit, Voice, Loyalty in 1970, other social scientists have added a fourth option to Hirschman’s framework: neglect.

* [Digital Notetaking Stack][24]

  > So, I’ve developed a system that works for taking paper notes. It’s custom tailored to my goals and how my brain works. And as a cherry on top, I picked a notebook binder and pen that I really enjoy touching and looking at, which makes the whole system just that much better.
  >
  > Similarly, I use a set of different apps for different purposes when I’m taking notes in my digital world.

* [Why note-taking apps don’t make us smarter][25]

  > Today let’s step outside the news cycle and turn our attention toward a topic I’m deeply invested in but only rarely write about: productivity platforms. For decades now, software tools have promised to make working life easier. But on one critical dimension — their ability to improve our thinking — they don’t seem to be making much progress at all.

[22]: https://calnewport.com/on-tools-and-the-aesthetics-of-work/
[23]: https://www.artofmanliness.com/character/behavior/exit-voice-loyalty-neglect-why-people-leave-stay-or-try-to-burn-it-all-down/
[24]: https://chrisnotes.io/digital-notetaking-stack
[25]: https://www.theverge.com/2023/8/25/23845590/note-taking-apps-ai-chat-distractions-notion-roam-mem-obsidian
