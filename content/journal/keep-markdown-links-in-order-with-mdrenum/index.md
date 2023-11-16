---
title: "Keep Markdown Links in Order With mdrenum"
date: 2023-11-15T12:00:00-05:00
draft: false
references:
- title: "Tidying Markdown reference links - All this"
  url: https://leancrew.com/all-this/2012/09/tidying-markdown-reference-links/
  date: 2023-11-15T03:08:29Z
  file: leancrew-com-7l5uqs.txt
---

I write all these posts in Markdown, and I tend to include a lot of links. I use numbered [reference-style links][1] and I like the numbers to be in sequential order. ([Here's the source of this post][2] to see what I mean.) I wrote a [Ruby script][3] to automate the process of renumbering links when I add a new one, and as mentioned in [last month's dispatch][4], I spent some time iterating on it to work with some new posts containing code blocks that I'd imported into my [Elsewhere][5] section.

[1]: https://www.markdownguide.org/basic-syntax/#reference-style-links
[2]: https://github.com/dce/davideisinger.com/blob/main/content/journal/keep-markdown-links-in-order-with-mdrenum/index.md?plain=1
[3]: https://github.com/dce/davideisinger.com/blob/e1d0590025fd8636c378748491fe11a0ba00b1ff/bin/renumber
[4]: /journal/dispatch-9-november-2023/
[5]: /elsewhere

<!--more-->

As I was working on the script, it was pretty easy to think of cases in which it would fail -- it can handle fenced code blocks, for example, but not ones set off by spaces. I thought it'd be cool to build something in Go that uses a proper Markdown parser instead of regular expressions. This might strike you as an esoteric undertaking, but as [Dr. Drang put it][6] when he embarked on a similar journey:

> But there is an attraction to putting everything in apple pie order, even when no one but me will ever see it.

[6]: https://leancrew.com/all-this/2012/09/tidying-markdown-reference-links/

## First Attempts with Go

My very first attempt involved the [`gomarkdown`][7] package. It was super straightforward to turn a Markdown document into an <abbr title="abstract syntax tree">AST</abbr>, but after an hour or so of investigation, it was pretty clear that I wasn't going to be able to get the original text and position of the links. I switched over to [`goldmark`][8], which is what this website uses to turn Markdown into HTML. This seemed a lot more promising -- it has functions for retrieving the content of nodes, as well as `start` and `stop` attributes that indicate position in the original text. I thought I had it nailed, but as I started writing tests, I realized there were certain cases where I couldn't perfectly locate the links -- two links smashed right up against one another, as an example. I spent a long time trying to come up with something that covered all the weird edge cases, but eventually gave up in frustration.

[7]: https://pkg.go.dev/github.com/gomarkdown/markdown/ast
[8]: https://github.com/yuin/goldmark

Both of these libraries are built to take Markdown, parse it, and turn it into HTML. That's fine, that's what Markdown is for, but for my use case, they came up short. I briefly considered forking `goldmark` to add the functionality I needed, but instead decided to look elsewhere.

## A Promising JavaScript Library

I searched for generic Markdown/AST libraries just to see what else was out there, and a [helpful Stackoverflow comment][9] led me to [`mdast-util-from-markdown`][10], a JavaScript library for working with Markdown without a specific output format. I pulled it down and ran the example code, and it was immediately obvious that it would provide the data I needed.

[9]: https://stackoverflow.com/a/74062924
[10]: https://github.com/syntax-tree/mdast-util-from-markdown

But now I had a new problem: I like JavaScript (and especially TypeScript) just fine, but I find the ecosystem around it bewildering, and furthermore, most of it is tailored for delivering complex functionality to browsers, not distributing simple command-line programs. I even went so far as to investigate using AI to convert the JS code to Go; the [solution][11] I found has some pretty severe character limitations, but I wonder if seamlessly converting code written in one language to another will be a thing in five years.

[11]: https://www.codeconvert.ai/typescript-to-golang-converter

## New JS Runtimes to the Rescue

On a whim, I decided to check out [Deno][12], a newer alternative to Node.js for server-side JS. Turns out it has the ability to [compile JS into standalone executables][13]. I downloaded it and ran it against the example code, and it worked! I got a (rather large) executable with the same output as running my script with Node. A coworker recommended I check out [Bun][14], which has [a similar compilation feature][15] -- it worked just as well, and the resulting executable was about a third the size as Deno's, so I opted to go with that.

[12]: https://deno.com/
[13]: https://docs.deno.com/runtime/manual/tools/compiler
[14]: https://bun.sh/
[15]: https://bun.sh/docs/bundler/executables

Once I had a working proof-of-concept and a toolchain I was happy with, the rest was all fun; writing recursive functions that work with tree structures to do useful work is extremely my shit ([here's an old post I wrote about _The Little Schemer_][16] along these same lines). I added [Jest][17] and pulled in all my Go tests, as well as [Prettier][18] to stand in for `gofmt`. I wrapped things up earlier this week and published the result, which I've imaginatively called `mdrenum`, to [GitHub][19].

[16]: /elsewhere/the-little-schemer-will-expand-blow-your-mind/
[17]: https://jestjs.io/
[18]: https://prettier.io/
[19]: https://github.com/dce/mdrenum

Bun (compiler) + TypeScript (type checking) + Prettier (code formatting) gets me most of what I like about working with Go, and I'm excited to use this tech in the future. The resulting executable is big (~45MB, as compared with ~2MB for my Go solution), but, hey, disk space is cheap and this actually works.

## Integrating with Helix

I've been a [happy Helix user][20] for the last several months, and I thought it'd be cool to configure it to automatically renumber links every time I save a Markdown file. [The docs][21] do a good job explaining how to add a language-specific formatter:

[20]: /journal/a-month-with-helix/
[21]: https://docs.helix-editor.com/languages.html#language-configuration

> The formatter for the language, it will take precedence over the lsp when defined. The formatter must be able to take the original file as input from stdin and write the formatted file to stdout

[This was simple to add to the program][22], and then I added the following to `~/.config/helix/languages.toml`:

```toml
[[language]]
name = "markdown"
auto-format = true
formatter = { command = "mdrenum" , args = ["--stdin"] }
```

[22]: https://github.com/dce/mdrenum/blob/main/src/cli.ts#L7-L18

This totally works, and I'll say that it's uniquely satisfying to save a document and see the link numbers get instantly reordered properly. I've done it probably 100 times in the course of writing this post.

---

Thanks for coming on this journey with me, and if this seems like a tool that might be useful to you, grab it from [GitHub][19] and open an issue if you have any questions.
