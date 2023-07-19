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

  > The return or result "parameters" of a Go function can be given names and used as regular variables, just like the incoming parameters. When named, they are initialized to the zero values for their types when the function begins; if the function executes a return statement with no arguments, the current values of the result parameters are used as the returned values.

* Type Conversion & Assertion
  * Built-in functions for conversion (`float64`, `strconv.Atoi`)
  * `if v, ok := fnb.(FancyNumber); ok {` (`v` is a `FancyNumber` if `ok` is true)
  * `switch v := i.(type) {` (case per type, `v` is `i` cast to that type)
* [Custom error types][19]

  > Usually, a struct is used to create a custom error type. By convention, custom error type names should end with `Error`. Also, it is best to set up the `Error() string` method with a pointer receiver, see this [Stackoverflow comment](https://stackoverflow.com/a/50333850) to learn about the reasoning. Note that this means you need to return a pointer to your custom error otherwise it will not count as `error` because the non-pointer value does not provide the `Error() string` method.

* [Maps][20]

  > A Go map type looks like this: `map[KeyType]ValueType`

  > To initialize a map, use the built in `make` function: `m = make(map[string]int)`

  > This statement retrieves the value stored under the key `"route"` and assigns it to a new variable i: `i := m["route"]`. If the requested key doesn’t exist, we get the value type’s _zero value_. In this case the value type is `int`, so the zero value is `0`.

  > A two-value assignment tests for the existence of a key: `i, ok := m["route"]`

  * [Insertion order has no effect on the order keys/values are retrieved in a `range` query][21]

    > The iteration order over maps is not specified and is not guaranteed to be the same from one iteration to the next.

* First-class functions
  * Go supports first-class functions (functions as arguments and return values of other functions)
  * Go has closures (so variables defined inside a function that returns a function get closed over)
  * Go has anonymous functions (`func` w/o name)
* Slices
  * Use `append` to add to a slice; this creates a new slice, so you have to capture the return value (`s = append(s, 100)`)
* `math/rand`
  * `rand.Intn`: random integer between 0 and the specified int
  * `rand.Float64`: random float between 0.0. and 1.0
  * `rand.Shuffle`: randomize an array/slice; takes a length and a swap function
* Stringers
  * Define a `String() string` method for types so that `fmt` knows how to stringify them
  * E.g. `fmt.Sprintf("%s", yourThing)` will call `yourThing`'s `String()` function
* Structs
  * [What Are Golang's Anonymous Structs?][22]

  > An anonymous struct is just like a normal struct, but it is defined without a name and therefore cannot be referenced elsewhere in the code.
  >
  > Structs in Go are similar to structs in other languages like C. They have typed collections of fields and are used to group data to make it more manageable for us as programmers.
  >
  > To create an anonymous struct, just instantiate the instance immediately using a second pair of brackets after declaring the type.

* [Time][23]
  * `time.Duration` -- `time.Second * 1e9` is a duration of one billion seconds
  * `1e9` is the same as `1.0*math.Pow(10, 9)`
* Runes
  * `unicode.IsLetter` -- test if rune is a letter
  * `strings.ContainsRune` -- test if string contains letter (`strings.ContainsRune(s[i+1:], c)`)
* `log.Println` -- print out anything (like a data structure)
* `strings.Map` -- map over a string
  * `return strings.Map(func(r rune) rune { return mapping[r] }, dna)`
* Generics
  * Use `[]` to define types
  * `func keep[T int | []int | string](in []T, filter func(T) bool) (out []T) {`
  * [Use `~` to allow "inheriting" (?) types][24]

  > In Go generics, the ~ tilde token is used in the form ~T to denote the set of types whose underlying type is T.

[17]: https://stackoverflow.com/a/40951013
[18]: https://go.dev/doc/effective_go#named-results
[19]: https://exercism.org/tracks/go/concepts/errors
[20]: https://go.dev/blog/maps
[21]: https://go.dev/ref/spec#RangeClause
[22]: https://blog.boot.dev/golang/anonymous-structs-golang/
[23]: https://pkg.go.dev/time
[24]: https://stackoverflow.com/a/70890514
