---
title: "A Month With Helix"
date: 2023-08-03T16:19:15-04:00
draft: false
references:
- title: "My thoughts on Helix after 6 months - Tim Hårek"
  url: https://timharek.no/blog/my-thoughts-on-helix-after-6-months/
  date: 2023-07-02T12:53:51Z
  file: timharek-no-ah7ilz.txt
---

As mentioned in [last month's dispatch][1], inspired by [a post from Tim Hårek][2], I've been using [Helix][3] exclusively for the last month. I'm using it right now to write this! It rips!

<!--more-->

I've been a Vim user since ~2010 after moving away from TextMate. I'm rather proficient in it, though it's an incredibly deep tool and there's always more to learn. I've become frustrated with my setup over the last few years, specifically around some conflicting plugins. I've intended to start from scratch with NeoVim, learn how to configure it with Lua, get the native language server stuff working properly, etc., but it's a lot of setup.

Helix, on the other hand, is a new editor, inspired by Vim and written in Rust. It doesn't support plugins and instead tries to be a fully-featured editor right out of the box. It has the same major modes as Vim (normal, insert, visual) but then also offers "minor modes" (e.g. hit `g` in normal mode for "goto" mode). It's cool, and it all works together well.

What I like:

* It's easy to get started
  * If you know Vim, you're like 75% of the way to Helix fluency
  * It has a nice tutorial
  * The minor modes feature little pop-up cheat sheets that make learning the various keyboard combos easy
* Stuff just makes sense, whereas some Vim stuff always struck me as arcane
  * e.g. `y` to yank; `space + y` to yank to the system clipboard
  * or `:theme` followed by a space displays a list of all available themes (`gruvbox` natch)
* Built-in language server support
  * `hx --health` makes it pretty clear how to get your language servers set up
* The multi-cursor stuff is nice once you get the hang of it
* It is simultaneously quite polished + under active development; several times I went looking for how to do something and found an active GitHub PR where the feature is being developed

What I don't like:

* It is very sensitive about external file changes; I switch git branches a lot, and if I'm working in one branch, then check out a different branch, and then switch back to the original branch, my next save is often rejected unless I remember to `w!`, which I often don't ([maybe fixed here?][4])
* Can't presently run multiple language servers for the same language
  * I'd really like to run both `standardrb` and `solargraph` when I'm working in Ruby
  * You can run a separate language server and formatter, which works fine, but there's a visible delay on save before the formatter kicks in, and you don't get nice in-editor warnings about style violations
  * It looks like this will be fixed in the next release
* Missing a couple key features from Vim plugins I'm quite fond of
  * [fugitive.vim][5]'s `:Git blame` view
  * A file system explorer like [NERDTree][6] -- the built-in fuzzy finder is awesome as long as you know the name of the file you're looking for, which I occasionally don't ([some progress here][7])
* I had to reconfigure how the option key works in iTerm and have lost my ability to type accented characters inside the terminal, which I've needed to do, I think, twice ([more info][8])

Pull it down with Homebrew or similar, and give it a shot. Hint: you launch Helix with `hx` -- figuring that out might've been the hardest part of my Helix journey so far.

[1]: /journal/dispatch-5-july-2023/
[2]: https://timharek.no/blog/my-thoughts-on-helix-after-6-months/
[3]: https://helix-editor.com/
[4]: https://github.com/helix-editor/helix/pull/7665
[5]: https://github.com/tpope/vim-fugitive
[6]: https://github.com/preservim/nerdtree
[7]: https://github.com/helix-editor/helix/pull/5768
[8]: https://github.com/helix-editor/helix/issues/2469
