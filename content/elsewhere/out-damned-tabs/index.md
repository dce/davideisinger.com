---
title: "Out, Damned Tabs"
date: 2009-04-09T00:00:00+00:00
draft: false
canonical_url: https://www.viget.com/articles/out-damned-tabs/
---

Like many developers I know, I'm a little bit OCD about code formatting.
While there are about as many ideas of properly formatted code as there
are coders, I think we can all agree that code with tabs and trailing
whitespace is not it. Git has the `whitespace = fix` option, which does
a fine job removing trailing spaces before commits, but leaves the
spaces in the working copy, and doesn't manage tabs at all.

I figured there had to be a better way to automate this type of code
formatting, and with help from [Kevin McFadden's
post](http://conceptsahead.com/off-axis/proper-trimming-on-save-with-textmate),
I think I've found one, by configuring
[TextMate](http://macromates.com/) to strip off trailing whitespace and
replace tabs with spaces whenever a file is saved. Here's how to set it
up:

1.  Open the Bundle Editor (Bundles \> Bundle Editor \> Show Bundle
    Editor).

2.  Create a new bundle using the "+" menu at the bottom of the page.
    Call it something like "Whitespace."

3.  With your new bundle selected, create a new command called "Save
    Current File," and give it the following settings:

    -   Save: Current File
    -   Command(s): blank
    -   Input: None
    -   Output: Discard

4.  Start recording a new macro (Bundles \> Macros \> Start Recording).

5.  Strip out trailing whitespace (Bundles \> Text \>
    Converting/Stripping \> Remove Trailing Spaces in Document).

6.  Replace tabs with spaces (Text \> Convert \> Tabs to Spaces).

7.  Save the current document (Bundles \> Formatting \> Save Current
    Document).

8.  Stop recording the macro (Bundles \> Macros \> Stop Recording).

9.  Save the macro (Bundles \> Macros \> Save Last Recording). Call it
    something like "Strip Whitespace."

10. Click in the Activation (Key Equivalent) text field and hit
    Command+S.

Alternatively, we've packaged the bundle up and put it up on
[GitHub](https://github.com/vigetlabs/whitespace-tmbundle/tree/master).
Instructions for setting it up are on the page, and patches are
encouraged.

### How About You?

This approach is working well for me; I'm curious if other people are
doing anything like this. If you've got an alternative way to deal with
extraneous whitespace in your code, please tell us how in the comments.
