---
title: "Extract Embedded Text from PDFs with Poppler in Ruby"
date: 2022-02-10T00:00:00+00:00
draft: false
canonical_url: https://www.viget.com/articles/extract-embedded-text-from-pdfs-with-poppler-in-ruby/
---

A recent client request had us adding an archive of magazine issues
dating back to the 1980s. Pretty straightforward stuff, with the hiccup
that they wanted the magazine content to be searchable. Fortunately, the
example PDFs they provided us had embedded text
content[^1], i.e. the
text was selectable. The trick was to figure out how to programmatically
extract that content.

Our first attempt involved the [`pdf-reader`
gem](https://rubygems.org/gems/pdf-reader/versions/2.2.1), which worked
admirably with the caveat that it had a little bit of trouble with
multi-column / art-directed layouts[^2], which was a lot of the content we were dealing
with.

A bit of research uncovered [Poppler](https://poppler.freedesktop.org/),
"a free software utility library for rendering Portable Document Format
(PDF) documents," which includes text extraction functionality and has a
corresponding [Ruby
library](https://rubygems.org/gems/poppler/versions/3.4.9). This worked
great and here's how to do it.

## Install Poppler

Poppler installs as a standalone library. On Mac:

```
brew install poppler
```

On (Debian-based) Linux:

```
apt-get install libgirepository1.0-dev libpoppler-glib-dev
```

In a (Debian-based) Dockerfile:

```dockerfile
RUN apt-get update &&
  apt-get install -y libgirepository1.0-dev libpoppler-glib-dev &&
  rm -rf /var/lib/apt/lists/*
````

Then, in your `Gemfile`:

```ruby
gem "poppler"
````

## Use it in your application

Extracting text from a PDF document is super straightforward:

```ruby
document = Poppler::Document.new(path_to_pdf)
document.map { |page| page.get_text }.join
```

The results are really good, and Poppler understands complex page
layouts to an impressive degree. Additionally, the library seems to
support a lot more [advanced
functionality](https://www.rubydoc.info/gems/poppler/3.4.9). If you ever
need to extract text from a PDF, Poppler is a good choice.

[*John Popper photo by Gage Skidmore, CC BY-SA
3.0*](https://commons.wikimedia.org/w/index.php?curid=39946499)


[^1]: Note that we're not talking about extracting text from images/OCR;
if you need to take an image-based PDF and add a selectable text
layer to it, I recommend
[OCRmyPDF](https://pypi.org/project/ocrmypdf/).

[^2]: So for a page like this:

        +-----------------+---------------------+
        | This is a story | my life got flipped |
        | all about how   | turned upside-down  |
        +-----------------+---------------------+

    `pdf-reader` would parse this into "This is a story my life got
    flipped all about how turned upside-down," which led to issues when
    searching for multi-word phrases.