---
title: "Three Magical Git Aliases"
date: 2012-04-25T00:00:00+00:00
draft: false
needs_review: true
canonical_url: https://www.viget.com/articles/three-magical-git-aliases/
---

Git is an enormously powerful tool, but certainly not the most
beginner-friendly. The basic commands are straightforward enough, but
until you wrap your head around its internal model, it's easy to wind up
in a jumble of merge commits or worse. Here are three aliases I use as
part of my daily workflow that help me avoid many of the common
pitfalls.

### GPP (`git pull --rebase && git push`)

**I can't push without pulling, and I can't pull without rebasing.** I'm
not sure this is still a point of debate, but if so, let me make my side
known: I hate hate *hate* merge commits. And of course, what does Git
tell you after an unsuccessful push?

    Merge the remote changes (e.g. 'git pull') before pushing again.

This will create a merge commit, regardless of whether there are any
conflicts between your changes and the remote. There are ways to prevent
these merge commits [at the configuration
level](https://viget.com/extend/only-you-can-prevent-git-merge-commits),
but they aren't foolproof. This alias is.

### GMF (`git merge --ff-only`)

**I can't create merge commits.** Similar to the last, this alias
prevents me from ever creating merge commits. I do my work in a topic
branch, and when the time comes to merge it back to the mainline
development branch, I check that branch out and pull down the latest
changes. At this point, if I were to type `git merge [branchname]`, I'd
create a merge commit.

Using this alias, though, the merge fails and I receive a warning that
this is not a [fast-forward
merge](https://365git.tumblr.com/post/504140728/fast-forward-merge). I
then check out my topic branch, rebase master, and then run the merge
successfully.

### GAP (`git add --patch`)

**I can't commit a code change without looking at it first.** Running
this command rather than `git add .` or using a commit flag lets me view
individual changes and decide whether or not I want to stage them. This
forces me to give everything I'm committing a final check and ensure
there isn't any undesirable code. It also allows me to break a set of
changes up into multiple commits, even if those changes are in the same
file.

What `git add --patch` doesn't do is stage new files, so you'll have to
add those by hand once you're done patching.

------------------------------------------------------------------------

Hope you find one or more of these aliases helpful. These *and more!*
available in my
[dotfiles](https://github.com/dce/dotfiles/blob/master/.aliases#L7).
