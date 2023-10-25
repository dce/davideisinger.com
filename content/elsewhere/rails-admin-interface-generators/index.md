---
title: "Rails Admin Interface Generators"
date: 2011-05-31T00:00:00+00:00
draft: false
canonical_url: https://www.viget.com/articles/rails-admin-interface-generators/
---

Here at Viget, we're always looking for ways to reduce duplicated
effort, and one component that nearly every single one of our
applications needs is an admin interface. As such, we've spent a lot of
time trying to find the perfect drop-in admin interface generator. We've
been happy with [Typus](https://github.com/fesplugas/typus) for the past
year or two and have been able to contribute back to the project on a
[number](https://github.com/fesplugas/typus/commit/3fb53f58ce606ae80beaa712eef81dcf0d6b03bc)
[of](https://github.com/fesplugas/typus/commit/b6ead488b218d187f948e85ec70c3b01a589ebae)
[occasions](https://github.com/fesplugas/typus/commit/00b7b47ebd97a630623e80c006ef5401060bd848).
Lately, though, a pair of new libraries have been making some noise:
[ActiveAdmin](http://activeadmin.info/) and
[RailsAdmin](https://github.com/sferik/rails_admin). How do they stack
up to Typus? Read on, friend.

### Typus

[Typus](https://github.com/fesplugas/typus) is a library by Francesc
Esplugas originally started in 2007. Typus takes a different approach
than the other two libraries in that it uses generated controllers that
live in your Rails app to serve up its pages, rather than keeping all of
its application code within the library. This approach offers (in this
author's opinion) increased extensibility at the expense of code
duplication --- it's dirt simple to override the (e.g.) `create` action
in your `Admin::CommentsController` when the need arises, but you'll
still need a separate controller for every model where the default
behavior is good enough.

Installing Typus is very straightforward: add the gem to your Gemfile,
bundle it, run `rails generate typus` to get a basic admin interface up,
then run `rails generate typus:migration` to get user authentication.
The authors of the plugin recently fixed one of my biggest gripes,
adding generators to make adding new admin controllers a snap.
Configuration is all handled by a few YAML files. In terms of looks,
Typus isn't going to win any awards out of the box, but they've made it
very simple to copy the views into your app's `views/` folder, where
you're free to override them.

### ActiveAdmin

I just heard about [ActiveAdmin](http://activeadmin.info/) from Peter
Cooper's [Ruby Weekly](http://rubyweekly.com/) newsletter, though the
project was started in April 2010. Before anything else, you have to
admit that the project homepage looks pretty nice, and I'm happy to
report that that same attention to aesthetics carries into the project
itself. Configuration files for each model in the admin interface are
written in Ruby and live in `app/admin`. It's clear that a lot of
thought has gone into the configuration API, and the [Github
page](https://github.com/gregbell/active_admin) contains thorough
documentation for how to use it.

I've long been jealous of [Django](https://www.djangoproject.com/)'s
generated admin interfaces, and ActiveAdmin is the first Rails project
I've seen that can rival it in terms of overall slickness, both from a
UI and development standpoint. The trouble with libraries that give you
so much out of the box is that it's often difficult to do things that
the author's didn't anticipate, and I'd need to spend more than an hour
with ActiveAdmin in order to determine if that's the case here.

### RailsAdmin

[RailsAdmin](https://github.com/sferik/rails_admin) is another recent
entry into the admin interface generator space, beginning as a Ruby
Summer of Code project in August of last year. I had some difficulty
getting it installed, finally having success after pointing the Gemfile
entry at the GitHub repository
(`gem 'rails_admin', :git => 'git://github.com/sferik/rails_admin.git'`).
The signup process was similarly unpolished, outsourcing entirely to
[Devise](https://github.com/plataformatec/devise) to the point that
anyone can navigate to `/users/sign_up` in your application and become
an admin.

Once inside the admin interface, things seem to work pretty well.
There's some interesting functionality available for associating models,
and the dashboard has some neat animated graphs. I'll be curious to
watch this project as it develops --- if they can smooth off some of the
rough edges, I think they'll really have something.

### Conclusion

[ActiveAdmin](http://activeadmin.info/) offers an incredibly slick
out-of-the-box experience; [Typus](https://github.com/fesplugas/typus)
seems to offer more ways to override default behavior. If I was starting
a new project today, it would depend on how much customization I thought
I'd have to do through the life of the project as to which library I
would choose. I put a small project called
[rails_admin_interfaces](https://github.com/dce/rails_admin_interfaces)
on GitHub with branches for each of these libraries so you can try them
out and draw your own conclusions.
