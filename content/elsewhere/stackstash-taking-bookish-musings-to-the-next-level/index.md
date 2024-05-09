---
title: "StackStash: Taking Bookish Musings to the Next Level"
date: 2024-04-09T00:00:00+00:00
draft: false
needs_review: true
canonical_url: https://www.viget.com/articles/stackstash-taking-bookish-musings-to-the-next-level/
---

We have many book lovers at Viget. Our #books Slack channel has a wealth
of information about what books people have read and how they felt about
them. While it's great to have access to that data, Slack doesn't
provide the type of exploratory, visual browsing experience that would
be most useful when trying to make decisions about what we might want to
read next.

We might wonder:

-   Has anyone read Tana French's The Likeness? How did they feel about
    it? 
-   Liz has shared books that I've enjoyed in the past. What other
    titles have they enjoyed?
-   What has everyone been reading lately?

During our latest Pointless Palooza, a team of 10 folks at Viget built
an app that would help us answer those types of questions in a more
engaging way. Rather than digging through a bunch of disparate threads
in Slack, we can now use the StackStash app to browse consolidated
information. It's easy to look at a book and see all of the people who
have mentioned it (and how they felt about it) or look at a person and
see all of the books they've mentioned (and how they felt about them).

{{<dither Group-9_2024-04-08-184917_kfjg.png "800x" />}}

## Behind the Scenes

When we build software for clients, their business needs typically drive
decisions around technical architecture, which then informs who works on
the project and their role. Pointless Palooza gives us an opportunity to
try out new technologies the team is excited about, and flex outside our
traditional roles. With a team of six (!) engineers slated to build
StackStash together, we needed to decide *how* to build the application
before we got started. This decision was guided by a few high-level
goals: 

-   Get a working end-to-end version of StackStash live on the Internet
    on Day 1 
-   Ensure everyone on the technical team could work on something that
    was interesting to them
-   Distribute the workload so that we wouldn't step on each other's
    toes 

Much like everything that happens in the software development lifecycle,
arriving at our final tech plan was an iterative process. In the days
leading up to kickoff, we worked collaboratively to settle on a fun mix
of technologies that play to our strengths while also giving us the
chance to try some new things: 

-   [Laravel](https://laravel.com/) for back-end data management,
    integrations with third-party sources ([Open
    Library](https://openlibrary.org/developers/api) and
    [OpenAI](https://openai.com/)) and the API layer  
-   [OpenAPI](https://www.openapis.org/) and
    [TypeSpec](https://typespec.io/docs/getting-started/getting-started-http)
    to define our API schema  
-   [Remix](https://remix.run/) + [React](https://react.dev/) as the
    view layer 
-   [PandaCSS](https://panda-css.com/) to style the React components and
    views 
-   [Docker](https://www.docker.com/) for local development and
    deployment

{{<dither CleanShot-2024-04-08-at-14.01.35.png "800x" />}}

## What We Learned

Bringing this concept to life was not only a fun experience but also
provided the team with the chance to learn new skills and technologies.
Here are some of the highlights that stood out to us:

### [Chris](https://www.viget.com/about/team/cmanning/)

**My favorite part of creating StackStash** was getting a chance to work
with Laravel, which was new to me on this project. I was surprised how
easy it was to find most information I was looking for right in the
main [Laravel documentation](https://laravel.com/docs/11.x). Overall, it
was a pleasant experience coming from other popular web frameworks like
Rails and Django.

**Something I learned** was a lot more about Slack API data. There were
a lot of little lessons I learned along the way---how message data is
generally structured, that [\`ts\` timestamps are kind of
IDs](https://api.slack.com/messaging/retrieving#:~:text=field.-,The,value%20is%20essentially%20the%20ID%20of%20the%20message,-%2C%20guaranteed%20unique%20within),
etc.---but the biggest surprise was that [the conversation history
API](https://api.slack.com/methods/conversations.history) we were
using [didn't include message
replies](https://www.bakejam.com/slacks-conversationshistory-api-ignores-replies/).
You can
retrieve [replies](https://api.slack.com/methods/conversations.replies)
via a similar endpoint, but as you might imagine, there are a lot more
API requests to account for.

### [Claire](https://www.viget.com/about/team/catwell/)

**My favorite part of creating StackStash** was working with a big team
of engineers to divide technical roles and responsibilities. Based on
experience from past client projects, we leveraged the "pods" concept,
assigning devs in teams of two to larger focus areas. I also enjoyed
queuing up work for everyone in a shared gist of our data spec vs.
breaking everything out into individual tickets. This was a huge
time-saver on the PM side and helped everyone collaborate more easily. 

**Something I learned** was how to write Migrations, Factories, and
Database Seeders in Laravel! 

### [Danny](https://www.viget.com/about/team/dbrown/)

**My favorite part of creating StackStash** was seeing similarities
between Laravel and other web frameworks. Even though the syntax was
pretty different, the general ideas for doing things was familiar enough
that it was easy to pick up and understand.

**Something I learned** was the interplay between Typespec, OpenAPI, and
TypeScript. I enjoyed learning with those three tools and how they work
together in such an enjoyable way. 

### [David](https://www.viget.com/about/team/deisinger/)

**My favorite part of creating StackStash** was getting to do some
modern PHP. It was the first language I used for web development (in the
late 90s 😯) but I haven't done a great job keeping up on its progress
over the last decade. The language, frameworks, and tooling have come a
long way. Laravel's slick, and having a language server to remind me the
argument order to \`implode\` was pretty clutch.  

**Something I learned** was how to write defensive PHP code. I was
working on a lot of the API integrations, and I took inspiration from Go
to be careful and explicit around failure. Also, a LOT
about [ISBN](https://en.wikipedia.org/wiki/ISBN)s.

### [Emily](https://www.viget.com/about/team/emcdonald/)

**My favorite part of creating StackStash** was designing new screens
based on the visual language and feature definition that were already
established. 

**Something I learned** was how to create animations in Figma! 

### [Jackson](https://www.viget.com/about/team/jfox/)

**My favorite part of creating StackStash** was getting more comfortable
using AI platforms like Google's Gemini and Anthropic's Claude for data
processing. I finally had a good reason to explore tools like Google's
AI Studio to help prototype prompts that became important components in
our data pipeline.

**Something I learned** was that AI tools can do some amazing things ---
we pulled JSON data out of Slack and had Gemini (and later GPT-4) doing
some very impressive data extraction and summarization --- but they're
also infuriatingly mysterious at times. Gemini and GPT both excel at
fuzzy tasks like summarization and sentiment analysis, but completely
fell down on lookup tasks, like gathering ISBNs for books. We eventually
switched to GPT-4 because we couldn't get consistently valid JSON out of
Gemini.

### [Laura](https://www.viget.com/about/team/lsweltz/)

**My favorite part of creating StackStash** was the opportunity to take
bookish joy at Viget to the next level. I hope that StackStash will help
my fellow book lovers find a great read the next time they're on the
hunt for a new book.

**Something I learned** was how to feel more comfortable and confident
when using Figma to create high-fidelity designs. As a researcher, I
primarily leverage Figma when conducting testing with prototypes. Things
like components, variants, and autolayout can feel intimidating to
someone who doesn't typically do in-the-weeds design work. This project
gave me an excuse to spend dedicated time learning how to use Figma
effectively for design production. 

### [Max](https://www.viget.com/about/team/mmyers/)

**My favorite part of creating StackStash** was seeing all the different
pieces come together to create something meaningful. Everyone was
working on their specific area and seeing it all intersect was really
cool.

**Something I learned** was OpenAPI and TypeSpec. It was a new
experience for me to work with OpenAPI to develop a spec for our API and
use that to test our API endpoints against. It really helped to make
sure everyone was able to be on the same page with the data we expected
in both the backend and frontend. I also got to dabble with TypeSpec to
generate the OpenAPI spec which was also a learning experience for me. I
enjoyed stepping out of PHP and into some new concepts.

### [Nathan](https://www.viget.com/about/team/nschmidt/)

**My favorite part of creating StackStash** was exploring all the
different AI models that are out there and testing which one would work
best for our project. 

**Something I learned** was... Laravel, AI, Remix, and Panda CSS. Worked
with Laravel when it first came out (8+ years ago) so there was a lot of
brushing up and relearning. Overall really like it and would love to use
Laravel again in another project. We went with Gemini AI to start with
as it had a really good free tier and it seemed to return what we needed
in a JSON format pretty consistently. But as we got more into
integrating it into our app data we noticed that Gemini did not return
perfect JSON every time. So we decided to change over to OpenAI as we
can set it to format the response into valid JSON. Also learned a lot
about Remix and Panda CSS as it was my first time working in both. There
was a learning curve but having worked with React it was pretty easy to
pick up. 

### [Nick](https://www.viget.com/about/team/ntelsan/)

**My favorite part of creating StackStash** was rapidly building a bunch
of UI in a familiar, but not too familiar, framework.

**Something I learned** was.... Laravel, Remix, more Docker magic,
TypeSpec, and more. I spent some time working with animations, which is
always both a treat and a slog. Getting everything set up and
it *mostly* just working for everyone was also a nice learning
experience.

------------------------------------------------------------------------

We learned quite a bit during Pointless Palooza --- and had fun while
doing so. In a short amount of time, our team successfully brought the
concept of StackStash to life. We're excited to see how the book lovers
at Viget make use of the tool and to potentially evolve it over time.
