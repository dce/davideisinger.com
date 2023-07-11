---
title: "Golang"
date: 2023-05-08T09:54:48-04:00
draft: false
references:
- title: "Why David Yach Loves Go"
  url: https://cloud.google.com/blog/products/application-modernization/why-david-yach-loves-go
  date: 2023-06-13T14:51:05Z
  file: cloud-google-com-windxx.txt
- title: "One process programming notes (with Go and SQLite)"
  url: https://crawshaw.io/blog/one-process-programming-notes
  date: 2023-06-13T14:49:51Z
  file: crawshaw-io-k5slfj.txt
- title: "Go Project Layout"
  url: https://medium.com/golang-learn/go-project-layout-e5213cdcfaa2
  date: 2023-06-13T15:00:02Z
  file: medium-com-efpmux.txt
- title: "Gopher Wrangling. Effective error handling in Go | Stephen's Tech Blog"
  url: https://stephenn.com/2023/06/gopher-wrangling.-effective-error-handling-in-go/
  date: 2023-06-20T16:25:12Z
  file: stephenn-com-kbiijs.txt
---

I find [Go][1] really compelling, even though it's not super applicable to my job. When evaluating a new tool, I find I'm weirdly biased to things written in Go.

* I like that it compiles, and have no desire to install someone else's Python
* It just seems to hit the right balance of productivity, performance, simplicity, safety
* The language (and the tech built with the language) just seems built to last

[1]: https://go.dev/

### Questions to Answer

* How to organize large(r) codebases
* Goroutines / concurrency
* Dev tooling
* How to read/write JSON
* How to validate with JSON Schema
  * <https://github.com/qri-io/jsonschema>
* Testing

### Projects I like

* [Hugo][2]
* [Caddy][3]
* [PocketBase][4]
* [SyncThing][5]
* [Restic][6]
* [Gotenberg][7]
* [Shiori][8]

[2]: https://gohugo.io/
[3]: https://caddyserver.com/
[4]: https://pocketbase.io/
[5]: https://syncthing.net/
[6]: https://restic.net/
[7]: https://gotenberg.dev/
[8]: https://github.com/go-shiori/shiori

### Project Ideas

* Bookmarking app (Pinboard replacement)
* Note-taking / journaling app
* [StevieBlocks][9]

{{<thumbnail project1 "400x" />}}

[9]: https://gist.github.com/dce/f975cb21b50a2cf998bf7230cbf89d85

### Resources

* [Standard Go Project Layout][10]
* [The files & folders of Go projects][11]
* [Why David Yach Loves Go][12]
* [One process programming notes (with Go and SQLite)][13]
* [Go Project Layout][14]
* [Gopher Wrangling. Effective error handling in Go][15]

[10]: https://github.com/golang-standards/project-layout
[11]: https://changelog.com/gotime/278
[12]: https://cloud.google.com/blog/products/application-modernization/why-david-yach-loves-go
[13]: https://crawshaw.io/blog/one-process-programming-notes
[14]: https://medium.com/golang-learn/go-project-layout-e5213cdcfaa2
[15]: https://stephenn.com/2023/06/gopher-wrangling.-effective-error-handling-in-go/

### Notes

* Regular Expressions
  * Compile with `regexp.MustCompile` (no need to check for error)
  * Strings denoted by backticks don't escape; use these for regular expressions
  * For case-insensitive matching, start the expression with `(?i)`
