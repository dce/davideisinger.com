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
- title: "Effective Go - The Go Programming Language"
  url: https://go.dev/doc/effective_go
  date: 2023-07-12T03:17:03Z
  file: go-dev-vfin4x.txt
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
* [Effective Go][16]

[10]: https://github.com/golang-standards/project-layout
[11]: https://changelog.com/gotime/278
[12]: https://cloud.google.com/blog/products/application-modernization/why-david-yach-loves-go
[13]: https://crawshaw.io/blog/one-process-programming-notes
[14]: https://medium.com/golang-learn/go-project-layout-e5213cdcfaa2
[15]: https://stephenn.com/2023/06/gopher-wrangling.-effective-error-handling-in-go/
[16]: https://go.dev/doc/effective_go

### Notes

* Regular Expressions
  * Compile with `regexp.MustCompile` (no need to check for error)
  * Strings denoted by backticks don't escape; use these for regular expressions
  * For case-insensitive matching, start the expression with `(?i)`
* [Unnamed parameters][17]

> Unnamed parameters are perfectly valid. The [Parameter declaration](https://golang.org/ref/spec#ParameterDecl) from the spec:
>
> ```
> ParameterDecl  = [ IdentifierList ] [ "..." ] Type .
> ````
>
> As you can see, the `IdentifierList` (the identifier name or names) is in square brackets, which means it's _optional_. Only the `Type` is required.
>
> The reason for this is because the names are not really important for someone calling a method or a function. What matters is the types of the parameters and their order. This is detailed in this answer: [Getting method parameter names in Golang](https://stackoverflow.com/questions/31377433/getting-method-parameter-names-in-golang/31377793#31377793)

* [Named result parameters][18]
* Type Conversion & Assertion
  * Built-in functions for conversion (`float64`, `strconv.Atoi`)
  * `if v, ok := fnb.(FancyNumber); ok {` (`v` is a `FancyNumber` if `ok` is true)
  * `switch v := i.(type) {` (case per type, `v` is `i` cast to that type)
* [Custom error types][19]

> Usually, a struct is used to create a custom error type. By convention, custom error type names should end with `Error`. Also, it is best to set up the `Error() string` method with a pointer receiver, see this [Stackoverflow comment](https://stackoverflow.com/a/50333850) to learn about the reasoning. Note that this means you need to return a pointer to your custom error otherwise it will not count as `error` because the non-pointer value does not provide the `Error() string` method.


[17]: https://stackoverflow.com/a/40951013
[18]: https://go.dev/doc/effective_go#named-results
[19]: https://exercism.org/tracks/go/concepts/errors
