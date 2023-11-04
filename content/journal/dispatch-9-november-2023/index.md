---
title: "Dispatch #9 (November 2023)"
date: 2023-11-01T00:00:00-04:00
draft: false
tags:
- dispatch
references:
- title: "EDM Song Structure: Arrange Your Loop into a Full Song"
  url: https://edmtips.com/edm-song-structure/
  date: 2023-11-02T03:01:04Z
  file: edmtips-com-05su6g.txt
- title: "The Tascam Portastudio 414 Let Me Fall In Love With Music Again"
  url: https://www.gearpatrol.com/tech/audio/a45461959/tascam-portastudio-414-mkii/
  date: 2023-11-02T03:06:19Z
  file: www-gearpatrol-com-6mp4nk.txt
- title: "The internet is already over - by Sam Kriss"
  url: https://samkriss.substack.com/p/the-internet-is-already-over
  date: 2023-11-02T03:10:20Z
  file: samkriss-substack-com-5indyq.txt
- title: "Why Culture Has Come to a Standstill - The New York Times"
  url: https://www.nytimes.com/2023/10/10/magazine/stale-culture.html
  date: 2023-11-02T03:15:31Z
  file: www-nytimes-com-yrjrte.txt
- title: "The Real Reason You Should Get an E-bike - The Atlantic"
  url: https://www.theatlantic.com/health/archive/2023/10/reasons-to-get-e-bike-emissions-climate-change-benefits/675716/
  date: 2023-10-29T18:17:07Z
  file: www-theatlantic-com-biphm9.txt
- title: "The beauty of finished software | Jose M."
  url: https://josem.co/the-beauty-of-finished-software/
  date: 2023-11-02T03:13:08Z
  file: josem-co-8ssbyq.txt
---

It was nice to have a quieter month after so much travel this summer. We got a few extra weeks of warm weather, which meant a few more weeks of biking with Nev, and plenty of time at the [museum][1] and all the local playgrounds. I decided to run the [Bull City Race Fest][2] half-marathon despite having to rest my ankle for the last week of training ([result][3], [certificate][4]). I faded pretty hard down the stretch, but still managed to finish in under two hours -- not bad for an old.

[1]: https://www.lifeandscience.org/
[2]: https://capstoneraces.com/bull-city-race-fest/
[3]: /journal/dispatch-9-november-2023/bcrf-result.pdf
[4]: /journal/dispatch-9-november-2023/bcrf-cert.png

<!--more-->

<div class="image-set">
  {{<thumbnail ECE91676-CF38-4F4D-9F8F-B6C87048AB16_1_105_c.jpeg "400x" />}}
  {{<thumbnail 59EA3598-4D50-4783-8EBF-CA35996F19E9_1_105_c.jpeg "400x" />}}
</div>

## Tech

At my job, I did a cool project working with data from a [Freematics][5] car telematics device. I built a data exploration API using [Gin][6] and learned [`jq`][7] to truncate enormous JSON objects[^1]. I also got to, just like, drive my car around to test things out.

{{<thumbnail golong.png "800x" />}}

I also made some updates to my [`golong`][8] tool to prep for a fantasy NBA draft. Now it can munge multiple CSVs of data and supports multiple position eligibility[^2] and average stat projections[^3]. It worked great, and my team's looking solid so far. I'll open source it one of these days.

[5]: https://freematics.com/products/freematics-one/
[6]: https://gin-gonic.com/
[7]: https://github.com/jqlang/jq
[8]: /journal/dispatch-7-september-2023/

## Music

I'm still having a blast with the Novation Circuit Tracks I got last month. I came up with a track I actually really like, which I'm calling "Radiatus" (which is a [type of cloud][9]):

<audio controls src="Radiatus.mp3"></audio>

[9]: https://cloudatlas.wmo.int/en/clouds-varieties-radiatus.html

Here's an extended mix:

<audio controls src="Radiatus (Extended).mp3"></audio>

It's really fun once you've got all the parts set up just to _play_ the Novation, bringing drums and leads in and out -- that's how I recorded these tracks. I imagine it'll only get more fun as I learn how to better twiddle the knobs to change the sounds. We'll see -- maybe I'll come up with 2-3 more cloud-themed tracks and release an album!

My phone (and yours probably) sends me these photo slideshows periodically, and I'm an absolute sucker for them. One recently featured a track by [Lack of Afro][10], and I've been listening to his stuff ever since. Check out "For You" (or really any of it -- it's all good).

[10]: https://lackofafro.com/

## Website

I made a few updates to the website this month:

* Created a [music][11] page that aggregates all the MP3s I've uploaded.
* Imported all the posts I've written on my [company blog][12] into an "[elsewhere][13]" section -- I'm pretty proud of some of this stuff and wanted to make sure I have a copy of it I control. I was able to automate a lot of the process with [Nokogiri][14] and [Pandoc][15], but I still had to manually review every post, which was a fun trip down memory lane, though some of my old ideas are BAD.
* Polished my [Markdown link renumbering script][25] (keeps my links in numerical order). This might be useful to other folks & might be worth rewriting in Go and releasing.

[11]: /music
[12]: https://www.viget.com/articles
[13]: /elsewhere
[14]: https://nokogiri.org/
[15]: /elsewhere/pandoc-a-tool-i-use-and-like/
[25]: https://github.com/dce/davideisinger.com/blob/main/bin/renumber

I'm really happy with Hugo -- it's simple but flexible enough to handle every challenge I've thrown at it. Building and maintaining this site has brought me a lot of joy this year.

This month:

* Adventure: head to upstate New York for Thanksgiving, run [Troy Turkey Trot][16]
* Project: make another track as good as that one 👆 and finally build that music workstation
* Skill: get better at playing along with a click track; [write songs, not just grooves][17]

[16]: https://troyturkeytrot.com/
[17]: https://edmtips.com/edm-song-structure/

Reading:

* Fiction: 
  * [_The Secret_][18], Lee Child & Andrew Child
  * [_Red War_][19], Kyle Mills
* Non-fiction: [_Step by Step Mixing_][20], [Bjorgvin Benediktsson][21]

[18]: https://www.penguinrandomhouse.com/books/635346/the-secret-by-lee-child-and-andrew-child/
[19]: https://www.vinceflynn.com/mitch-rapp-17
[20]: https://bookshop.org/p/books/step-by-step-mixing-how-to-create-great-mixes-using-only-5-plug-ins-bjorgvin-benediktsson/9946155?ean=9781733688802
[21]: https://www.stepbystepmixing.com/

Links:

* [The Tascam Portastudio 414 Let Me Fall In Love With Music Again][22]

  > For the past ten years or so I've been a musical rut, playing the same half-dozen, half-written songs on guitar once every other blue moon and listening to the same handful of punk bands I listened to in high school. I’ve been a musician for most of my life. Between church choirs, garage bands, and a cappella groups, I’ve been involved in organized (but never professional) music-making for the better part of several decades. But, after so long uninspired, I thought that maybe the musical part of my life was mostly behind me. Until the Tascam Portastudio 414 MKII brought it all flooding back.

* [The internet is already over][23]

  > Where you go, what you buy; a perfect snapshot of millions of ordinary lives. They were betting that this would be the currency of the future, as fundamental as oil: the stuff that rules the world.
  >
  > They were wrong, but in the process of being wrong, they created a monster.

* [Why Culture Has Come to a Standstill][26]

  > If there is one cultural work that epitomizes this shift, where you can see our new epoch coming into view, I want to say it’s “Back to Black,” by Amy Winehouse. The album dates to October 2006 — seven months after Twitter was founded, three months before the iPhone debuted — and it seems, listening again now, to be closing the door on the cultural system that Manet and Baudelaire established a century and a half previously.

* [The Real Reason You Should Get an E-bike][24]

  > Today’s happiness and personal-finance gurus have no shortage of advice for living a good life. Meditate daily. Sleep for eight hours a night. Don’t forget to save for retirement. They’re not wrong, but few of these experts will tell you one of the best ways to improve your life: Ditch your car.

* [The beauty of finished software][25]

  > It does everything I want a word processing program to do and it doesn't do anything else. I don't want any help. I hate some of these modern systems where you type up a lowercase letter and it becomes a capital. I don't want a capital, if I'd wanted a capital, I would have typed the capital.

[22]: https://www.gearpatrol.com/tech/audio/a45461959/tascam-portastudio-414-mkii/
[23]: https://samkriss.substack.com/p/the-internet-is-already-over
[26]: https://www.nytimes.com/2023/10/10/magazine/stale-culture.html
[24]: https://www.theatlantic.com/health/archive/2023/10/reasons-to-get-e-bike-emissions-climate-change-benefits/675716/
[25]: https://josem.co/the-beauty-of-finished-software/

[^1]: I was getting back complex nested JSON structures containing arrays with thousands of elements. To truncate all arrays in a JSON response to two elements, you can do `curl [url] | jq 'walk(if type == "array" then .[0:2] else . end)'`.
[^2]: An NBA player is often eligible as both a forward and a center, for example.
[^3]: NFL projections are typically season-based, NBA are per-game -- the tool can now take per-game projections multiplied by projected games played to get total points.
