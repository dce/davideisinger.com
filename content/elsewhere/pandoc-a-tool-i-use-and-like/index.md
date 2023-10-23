---
title: "Pandoc: A Tool I Use and Like"
date: 2022-05-25T00:00:00+00:00
draft: false
needs_review: true
canonical_url: https://www.viget.com/articles/pandoc-a-tool-i-use-and-like/
---

Today I want to talk to you about one of my favorite command-line tools,
[Pandoc](https://pandoc.org/). From the project website:

> If you need to convert files from one markup format into another,
> pandoc is your swiss-army knife.

I spend a lot of time writing, and I love [Vim](https://www.vim.org/),
[Markdown](https://daringfireball.net/projects/markdown/), and the
command line (and avoid browser-based WYSIWYG editors when I can), so
that's where a lot of my Pandoc use comes in, but it has a ton of
utility outside of that -- really, anywhere you need to move between
different text-based formats, Pandoc can probably help. A few examples
from recent memory:

### Markdown ➞ Craft Blog Post

This website you're reading presently uses [Craft
CMS](https://craftcms.com/), a flexible and powerful content management
system that doesn't perfectly match my writing
process[^1^](#fn1){#fnref1 .footnote-ref role="doc-noteref"}. Rather
than composing directly in Craft, I prefer to write locally, pipe the
output through Pandoc, and put the resulting HTML into a text block in
the CMS. This gets me a few things I really like:

-   Curly quotes in place of straight ones and en-dashes in place of
    `--` (from the [`smart`
    extension](https://pandoc.org/MANUAL.html#extension-smart))
-   [Daring
    Fireball-style](https://daringfireball.net/2005/07/footnotes)
    footnotes with return links

By default, Pandoc uses [Pandoc
Markdown](https://garrettgman.github.io/rmarkdown/authoring_pandoc_markdown.html)
when converting Markdown docs to other formats, an "extended and
slightly revised version" of the original syntax, which is how footnotes
and a bunch of other things work.

### Markdown ➞ Rich Text (Basecamp)

I also sometimes find myself writing decently long
[Basecamp](https://basecamp.com/) posts. Basecamp 3 has a fine WYSIWYG
editor (🪦 Textile), but again, I'd rather be in Vim. Pasting HTML into
Basecamp doesn't work (just shows the code verbatim), but I've found
that if I convert my Markdown notes to HTML and open the HTML in a
browser, I can copy and paste that directly into Basecamp with good
results. Leveraging MacOS' `open` command, this one-liner does the
trick[^2^](#fn2){#fnref2 .footnote-ref role="doc-noteref"}:

    cat [filename.md] 
      | pandoc -t html 
      > /tmp/output.html 
      && open /tmp/output.html 
      && read -n 1 
      && rm /tmp/output.html

This will convert the contents to HTML, save that to a file, open the
file in a browser, wait for the user to hit enter, and the remove the
file. Without that `read -n 1`, it'll remove the file before the browser
has a chance to open it.

### HTML ➞ Text

We built an app for one of our clients that takes in news articles (in
HTML) via an API and sends them as emails to *their* clients (think big
brands) if certain criteria are met. Recently, we were making
improvements to the plain text version of the emails, and we noticed
that some of the articles were coming in without any linebreaks in the
content. When we removed the HTML (via Rails' [`strip_tags`
helper](https://apidock.com/rails/ActionView/Helpers/SanitizeHelper/strip_tags)),
the resulting content was all on one line, which wasn't very readable.
So imagine an article like this:

    <h1>Headline</h1> <p>A paragraph.</p> <ul><li>List item #1</li> <li>List item #2</li></ul>

Our initial approach (with `strip_tags`) gives us this:

    Headline A paragraph. List item #1 List item #2

Not great! But fortunately, some bright fellow had the idea to pull in
Pandoc, and some even brighter person packaged up some [Ruby
bindings](https://github.com/xwmx/pandoc-ruby) for it. Taking that same
content and running it through `PandocRuby.html(content).to_plain` gives
us:

    Headline

    A paragraph.

    -   List item #1
    -   List item #2

Much better, and though you can't tell from this basic example, Pandoc
does a great job with spacing and wrapping to generate really
nice-looking plain text from HTML.

### HTML Element ➞ Text

A few months ago, we were doing Pointless Weekend and needed a domain
for our
[Thrillr](https://www.viget.com/articles/plan-a-killer-party-with-thrillr/)
app. A few of us were looking through lists of fun top-level domains,
but we realized that AWS Route 53 only supports a limited set of them.
In order to get everyone the actual list, I needed a way to get all the
content out of an HTML `<select>` element, and you'll never guess what I
did (unless you guessed "use Pandoc"). In Firefox:

-   Right click the select element, then click "Inspect"
-   Find the `<select>` in the DOM view that pops up
-   Right click it, then go to "Copy", then "Inner HTML"
-   You'll now have all of the `<option>` elements on your clipboard
-   In your terminal, run `pbpaste | pandoc -t plain`

The result is something like this:

    .ac - $76.00
    .academy - $12.00
    .accountants - $94.00
    .agency - $19.00
    .apartments - $47.00
    .associates - $29.00
    .au - $15.00
    .auction - $29.00
    ...

### Preview Mermaid/Markdown (`--standalone`)

A different client recently asked for an architecture diagram of a
complex system that [Andrew](https://www.viget.com/about/team/athomas/)
and I were working on, and we opted to use
[Mermaid](https://mermaid-js.github.io/mermaid/#/) (which is rad BTW) to
create sequence diagrams to illustrate all of the interactions. Both
GitHub and GitLab support Mermaid natively, which is really neat, but we
wanted a way to quickly iterate on our diagrams without having to push
changes to the remote repo.

We devised a simple build chain ([demo version available
here](https://github.com/dce/mermaid-js-demo)) that watches for changes
to a Markdown file, converts the Mermaid blocks to SVG, and then uses
Pandoc to take the resulting document and convert it to a styled HTML
page using the `--standalone` option ([here's the key
line](https://github.com/dce/mermaid-js-demo/blob/main/bin/build#L7=)).
Then we could simply make our changes and refresh the page to see our
progress.

### Generate a PDF

Finally, and this is not something I need to do very often, but Pandoc
also includes several ways to create PDF documents. The simplest (IMO)
is to install `wkhtmltopdf`, then instruct Pandoc to convert its input
to HTML but use `.pdf` in the output filename, so something like:

    echo "# Hello\n\nIs it me you're looking for?" | pandoc -t html -o hello.pdf

[The result is quite nice.](https://static.viget.com/hello.pdf)

------------------------------------------------------------------------

I think that's about all I have to say about Pandoc for today. A couple
final thoughts:

-   Pandoc is incredibly powerful -- I've really only scratched the
    surface here. Look at the [man page](https://manpages.org/pandoc) to
    get a sense of everything it can do.
-   Pandoc is written in Haskell, and [the
    source](https://github.com/jgm/pandoc/blob/master/src/Text/Pandoc/Readers/Markdown.hs)
    is pretty fun to look through if you're a certain kind of person.

So install Pandoc with your package manager of choice and give it a
shot. I think you'll find it unexpectedly useful.

*[Swiss army knife icons created by smalllikeart -
Flaticon](https://www.flaticon.com/free-icons/swiss-army-knife "swiss army knife icons")*


------------------------------------------------------------------------

1.  [My writing process is (generally):]{#fn1}
    1.  Write down an idea in my notebook
    2.  Gradually add a series of bullet points (this can sometimes take
        awhile)
    3.  Once I feel like I have a solid outline, copy that into a
        Markdown file
    4.  Start collecting links (in the `[1]:` footnote style)
    5.  Write a intro
    6.  Convert the bullet points to headers, edit + rearrange
    7.  Fill in all the sections, write jokes, etc.
    8.  Write a conclusion
    9.  Create a Gist, get feedback from the team
    10. Convert Markdown to HTML, copy to clipboard
        (`cat [file] | pandoc -t html | pbcopy`)
    11. Create a new post in Craft, add a text section, flip to code
        view, paste clipboard contents
    12. Fill in the rest of the post metadata
    13. 🚢 [↩︎](#fnref1){.footnote-back role="doc-backlink"}

2.  [I've actually got this wired up as a Vim command in
    `.vimrc`:]{#fn2}

        command Mdpreview ! cat %
              \ | pandoc -t html
              \ > /tmp/output.html
              \ && open /tmp/output.html
              \ && read -n 1
              \ && rm /tmp/output.html

    [↩︎](#fnref2){.footnote-back role="doc-backlink"}
