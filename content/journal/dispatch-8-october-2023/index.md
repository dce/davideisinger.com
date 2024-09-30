---
title: "Dispatch #8 (October 2023)"
date: 2023-10-06T14:08:30-04:00
draft: false
tags:
- dispatch
references:
- title: "Sansone beach in Portoferraio, on the Island of Elba"
  url: https://www.infoelba.com/island-of-elba/beaches/sansone-beach/
  date: 2023-10-10T13:36:18Z
  file: www-infoelba-com-pmih4w.txt
- title: "Cavo, Island of Elba"
  url: https://www.infoelba.com/discovering-elba/communes-towns/rio-marina/cavo/
  date: 2023-10-10T13:36:21Z
  file: www-infoelba-com-beacbk.txt
- title: "gokrazy is really cool - Xe Iaso"
  url: https://xeiaso.net/blog/gokrazy/
  date: 2023-10-10T02:50:31Z
  file: xeiaso-net-ygnwtd.txt
- title: "I Finally Reached Computing Nirvana. What Was It All For? | WIRED"
  url: https://www.wired.com/story/i-finally-reached-computing-nirvana-what-was-it-all-for/
  date: 2023-10-10T02:50:32Z
  file: www-wired-com-ybjipw.txt
- title: "Style is consistent constraint — Steph Ango"
  url: https://stephango.com/style
  date: 2023-10-10T02:50:32Z
  file: stephango-com-tiumoc.txt
---

Italy was grand, what an adventure. We spent a little over a week in Tuscany, mostly on Elba Island, with quick visits to Siena and Florence on our way out. [Our accomodations on Elba][1] were awesome, and other highlights included [Spiaggia di Sansone][2], [Cavo][3], and revisiting a few favorite spots in Siena and Florence (the pizza at [Il Pomodorino][4] was as good as we remembered). 

<!--more-->

It wasn't all perfectly smooth -- Nev had a tough time with jet lag, and driving through Italy was stressful, but a week later, that stuff's all faded away and what remains are the great memories.

[1]: https://www.rosselbalepalme.it/en/glamping-lodge.php
[2]: https://www.infoelba.com/island-of-elba/beaches/sansone-beach/
[3]: https://www.infoelba.com/discovering-elba/communes-towns/rio-marina/cavo/
[4]: https://ilpomodorino.it/

{{<dither IMG_4710.jpeg "510x" />}}
{{<dither IMG_4771.jpeg "510x" />}}
{{<dither IMG_4781.jpeg "510x" />}}

{{<dither IMG_4809.jpeg "510x" />}}
{{<dither IMG_4842.jpeg "510x" />}}
{{<dither IMG_4886.jpeg "510x" />}}

I downloaded the [Airalo][5] app before I left, which offers cheap international data plans using e-SIM cards. The app works great, no complaints there, but mixed feelings about having a working phone while on vacation -- it was cool to be able to send photos + make video calls, but my company's going through some tough times and I couldn't pull myself away from Slack and email.

[5]: https://www.airalo.com/

I had a birthday right before we left, and I decided to gift myself a [Novation Circuit Tracks][6], a portable synthesizer and drum machine. This thing is neat! Four drum tracks, two synths, and the ability to control other gear with MIDI. I've only had it about a week and I'm already feeling relatively proficient. Here are a couple demos:

[6]: https://us.novationmusic.com/products/circuit-tracks

<audio controls src="/journal/dispatch-8-october-2023/Demo 1.mp3"></audio>
<audio controls src="/journal/dispatch-8-october-2023/Demo 2.mp3"></audio>

On that second one, the Circuit is using MIDI signals to play my [digital piano][7], which is then sending audio back into the Circuit. I'm just using the voice memos app (of all things) to record the output; I'll probably need to get a proper <abbr title="digital audio workstation">DAW</abbr> set up if I'm going to get more ambitious, but for now, it's pretty fun to create tracks with just a hardware device.

[7]: https://usa.yamaha.com/products/music_production/synthesizers/reface/reface_cp.html

Making music, especially digitally, appeals equally to my mathematical and creative brains; it's so cool to punch a rhythm into a grid and hear something pretty good come out. And it's cool that music hardware is pretty much all MIDI + audio signals, and you can combine devices in unlimited ways (the flipside being that my gear wishlist is growing by the day).

I was anticipating a longer learning curve with the Circuit, and was kind of surprised that I was making tracks basically as good as I've ever done within a few days; maybe it's just an intuitively-designed tool, but more realistically, I'm just not a very sophisticated musician. I feel that way about a lot of hobbies -- I gain a level of basic competence and just kind of stay there. Someone recently asked how long I'd been playing guitar, and I said, well, I guess 25 years, but I'm like 1.5 years good. Maybe I'll always be a dabbler, and maybe that's OK! I certainly get a lot of joy out of these activities. But I can't help but compare myself to, like, [Bonobo][8] and feel like that's what I should be striving for.

[8]: https://bonobomusic.com/

### This Month

* Adventure: [Bull City Race Fest][9] half-marathon next weekend, then, if I'm feeling frisky, keep my training up and register for [City of Oaks][10]. The other night, I was running after dark and managed to tweak my ankle in the last 20 feet -- the perils of trying to balance work, parenting, and training, I guess.
* Project:
  * Build a music workstation -- I need some more desk space for gear, cables, and power
  * Prep my `Golong` app for the upcoming NBA draft, then open source it & write a post about it
  * Write a program in Go to pull interesting stats from my fantasy leagues using this [`yfquery` library][11]
* Skill: keep making musical tracks + refining my workflows

[9]: https://capstoneraces.com/bull-city-race-fest/
[10]: https://cityofoaksmarathon.com/
[11]: https://github.com/famendola1/yfquery

### Reading

* Fiction:
	* [_Double or Nothing_][12], Kim Sherwood
	* [_Enemy of the State_][13], Kyle Mills
* Non-fiction: [_Step by Step Mixing_][14], [Bjorgvin Benediktsson][15]

[12]: https://bookshop.org/p/books/double-or-nothing-a-double-o-novel-kim-sherwood/18644028?ean=9780063236516
[13]: https://bookshop.org/p/books/enemy-of-the-state-vince-flynn/6701730?ean=9781982147525
[14]: https://bookshop.org/p/books/step-by-step-mixing-how-to-create-great-mixes-using-only-5-plug-ins-bjorgvin-benediktsson/9946155?ean=9781733688802
[15]: https://www.stepbystepmixing.com/

### Links

* [gokrazy is really cool][16]

  > gokrazy is a Linux implementation that I've used off and on for a few years now. It's a very interesting project because everything on the system is written in Go save the kernel. The init process is in Go (and even listens over HTTP to handle updates!), every userland process is written in Go, and even the core system services are written in Go.

* [I Finally Reached Computing Nirvana. What Was It All For?][17]

  > Then, one cold day—January 31, 2022—something bizarre happened. I was at home, writing a little glue function to make my emails searchable from anywhere inside my text editor. I evaluated that tiny program and ran it. It worked. Somewhere in my brain, I felt a distinct _click_. I was done. No longer configuring, but configured. The world had conspired to give me what I wanted.

* [Style is consistent constraint][18]

  > When it comes to ideas, I agree — allow your mind to be changed. When it comes to process, I disagree. Style emerges from consistency, and having a style opens your imagination. Your mind should be flexible, but your process should be repeatable.

[16]: https://xeiaso.net/blog/gokrazy/
[17]: https://www.wired.com/story/i-finally-reached-computing-nirvana-what-was-it-all-for/
[18]: https://stephango.com/style
