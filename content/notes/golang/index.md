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

[2]: https://gohugo.io/
[3]: https://caddyserver.com/
[4]: https://pocketbase.io/
[5]: https://syncthing.net/
[6]: https://restic.net/

### Project Ideas

* Bookmarking app (Pinboard replacement)
* Note-taking / journaling app
* [StevieBlocks][7]

{{<thumbnail project1 "400x" />}}

[7]: https://gist.github.com/dce/f975cb21b50a2cf998bf7230cbf89d85

### Resources

* [Standard Go Project Layout][8]
* [The files & folders of Go projects][9]
* [Why David Yach Loves Go][10]
* [One process programming notes (with Go and SQLite)][11]
* [Go Project Layout][12]

[8]: https://github.com/golang-standards/project-layout
[9]: https://changelog.com/gotime/278
[10]: https://cloud.google.com/blog/products/application-modernization/why-david-yach-loves-go
[11]: https://crawshaw.io/blog/one-process-programming-notes
[12]: https://medium.com/golang-learn/go-project-layout-e5213cdcfaa2
