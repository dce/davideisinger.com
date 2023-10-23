---
title: "Single-Use jQuery Plugins"
date: 2009-07-16T00:00:00+00:00
draft: false
needs_review: true
canonical_url: https://www.viget.com/articles/single-use-jquery-plugins/
---

One of the best features of [jQuery](http://jquery.com/) is its simple,
powerful plugin system. The most obvious reason to write a plugin is the
same reason you'd create a Rails plugin: to package up functionality for
reuse. While code reuse between projects is certainly a worthy goal, it
sets a prohibitively high bar when deciding whether or not to pull a
piece of functionality into a plugin.

There are a number of good reasons to create jQuery plugins for behavior
specific to the app under development. Consider the following example, a
simple plugin to create form fields for an arbitrary number of nested
resources, adapted from a recent project:

    (function($) { $.fn.cloneableFields = function() { return this.each(function() { var container = $(this); var fields = container.find("fieldset:last"); var label = container.metadata().label || "Add"; container.count = function() { return this.find("fieldset").size(); }; // If there are existing entries, hide the form fields by default if (container.count() > 1) { fields.hide(); } // When link is clicked, add a new set of fields and set their keys to // the total number of fieldsets, e.g. instruction_attributes[5][name] var addLink = $("<a/>").text(label).click(function() { html = fields.html().replace(/\[\d+\]/g, "[" + container.count() + "]"); $(this).before("<fieldset>" + html + "</fieldset>"); return false; }); container.append(addLink); }); }; })(jQuery); 

## Cleaner Code {#cleaner_code}

When I was first starting out with jQuery and unobtrusive JavaScript, I
couldn't believe how easy it was to hook into the DOM and add behavior.
I ended up with monstrous `application.js` files consisting solely of
giant `$(document).ready()` functions --- exactly the kind of spaghetti
code I switched to Ruby and Rails to avoid. A pre-refactoring version of
[SpeakerRate](http://www.speakerrate.com) had one over 700 lines long.

By pulling this feature into a plugin, rather than some version of the
above code in our `$(document).ready()` function, we can stash it in a
separate file and replace it with a single line:

    $("div.cloneable").cloneableFields(); 

Putting feature details into separate files turns our `application.js`
into a high-level view of the behavior of the site.

## State Maintenance {#state_maintenance}

In JavaScript, functions created inside of other functions maintain a
link to variables declared in the outer function. In the above example,
we create variables called `container` and `fields` when the page is
loaded, and then access those variables in the `click()` handler of the
inserted link. This way, we can avoid performing potentially expensive
jQuery selectors every time an event is fired.

Right now, you might be thinking, "But David, isn't
`$(document).ready()` also a function? Shouldn't this same principle
apply?" Yes and no, dear reader. Variables declared in
`$(document).ready()` can be accessed by functions declared there, but
since it's only called once, there will only be one copy of those
variables for the page. By using the standard `return this.each()`
plugin pattern, we ensure that there will be a copy of our variables for
each selector match, so that we can have multiple sets of
CloneableFields on a single page.

## Faster Scripts {#faster_scripts}

Aside from being able to store the results of selectors in variables,
there are other performance gains to be had by containing your features
in plugins. If a behavior involves attaching event listeners to five
different DOM elements, rather than running selectors to search for each
of these elements when the page loads, we'll get better performance by
searching for a containing element and then invoking our plugin on it,
since we'll only have to make one call on pages that don't have the
feature. Furthermore, inside your plugin, you'll be more inclined to
scope your selectors properly, further increasing performance.

If you opt to put your features into separate files, make sure compress
all your JavaScript into one file in production to reduce the number of
HTTP requests.

## Conclusion

As Rubyists, the reasons to package up jQuery features follow many of
the ideas to which we already subscribe: DRY, separation of concerns,
and idiomatic code. Using jQuery plugins is by no means the only way to
achieve clean JavaScript; the April edition of
[JSMag](http://www.jsmag.com/main.issues.description/id=19/) has a great
article about containing features within object literals, a more
framework-agnostic approach. Whatever method you choose, do *something*
to avoid the novel-length `$(document).ready()` function. Your future
self will thank you for it.
