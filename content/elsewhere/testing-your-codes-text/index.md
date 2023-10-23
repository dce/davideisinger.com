---
title: "Testing Your Code’s Text"
date: 2011-08-31T00:00:00+00:00
draft: false
needs_review: true
canonical_url: https://www.viget.com/articles/testing-your-codes-text/
---

The "Ubiquitous Automation" chapter of [*The Pragmatic
Programmer*](https://books.google.com/books?id=5wBQEp6ruIAC&lpg=PA254&vq=ubiquitous%20automation&pg=PA230#v=onepage&q&f=false)
opens with the following quote:

> Civilization advances by extending the number of important operations
> we can perform without thinking.
>
> --Alfred North Whitehead

As a responsible and accomplished developer, when you encounter a bug in
your application, what's the first thing you do? Write a failing test
case, of course, and only once that's done do you focus on fixing the
problem. But what about when the bug is not related to the *behavior* of
your application, but rather to its configuration, display, or some
other element outside the purview of normal testing practices? I contend
that you can and should still write a failing test.

**Scenario:** In the process of merging a topic branch into master, you
encounter a conflict in one of your ERB files. You fix the conflict and
commit the resolution, run the test suite, and then deploy your changes
to production. An hour later, you receive an urgent email from your
client wondering what happened to the footer of their site. As it turns
out, there were *two* conflicts in the file, and you only fixed the
first, committing the conflict artifacts of the second into the repo.

Your gut instinct is to zip off a quick fix, write a self-deprecating
commit message, and act like the whole thing never happened. But
consider writing a rake task like this:

    namespace :preflight do task :git_conflict do paths = `grep -lir '<<<\\|>>>' app lib config`.split(/\n/) if paths.any? puts "\ERROR: Found git conflict artifacts in the following files\n\n" paths.each {|path| puts " - #{path}" } exit 1 end end end 

This task greps through your `app`, `lib`, and `config` directories
looking for occurrences of `<<<` or `>>>` and, if it finds any, prints a
list of the offending files and exits with an error. Hook this into the
rake task run by your continuous integration server and never worry
about accidentally deploying errant git artifacts again:

    namespace :preflight do task :default do Rake::Task['cover:ensure'].invoke Rake::Task['preflight:all'].invoke end task :all do Rake::Task['preflight:git_conflict'].invoke end task :git_conflict do paths = `grep -lir '<<<\\|>>>' app lib config`.split(/\n/) if paths.any? puts "\ERROR: Found git conflict artifacts in the following files\n\n" paths.each {|path| puts " - #{path}" } exit 1 end end end Rake::Task['cruise'].clear task :cruise => 'preflight:default' 

We've used this technique to keep our deployment configuration in order,
to ensure that we're maintaining best practices, and to keep our
applications in shape as they grow and team members change. Think of it
as documentation taken to the next level -- text to explain the best
practice, code to enforce it. Assuming you're diligent about running
your tests, every one of these tasks you write is a problem that will
never make it to production.
