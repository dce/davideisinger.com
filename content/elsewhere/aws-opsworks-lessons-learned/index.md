---
title: "AWS OpsWorks: Lessons Learned"
date: 2013-10-04T00:00:00+00:00
draft: false
canonical_url: https://www.viget.com/articles/aws-opsworks-lessons-learned/
---

We've been using Amazon's [AWS
OpsWorks](http://aws.amazon.com/opsworks/) to manage our infrastructure
on a recent client project. The website describes OpsWorks as

> a DevOps solution for managing applications of any scale or complexity
> on the AWS cloud.

You can think of it as a middleground between something like Heroku and
a manually configured server environment. You can also think of it as
[Chef](http://www.opscode.com/chef/)-as-a-service. Before reading on,
I'd recommend reading this [Introduction to AWS
OpsWorks](http://artsy.github.io/blog/2013/08/27/introduction-to-aws-opsworks/),
a post I wish had existed when I was first diving into this stuff. With
that out of the way, here are a few lessons I had to learn the hard way
so hopefully you won't have to.

### You'll need to learn Chef

The basis of OpsWorks is [Chef](http://www.opscode.com/chef/), and if
you want to do anything interesting with your instances, you're going to
have to dive in, fork the [OpsWorks
cookbooks](https://github.com/aws/opsworks-cookbooks), and start adding
your own recipes. Suppose, like we did, you want to add
[PDFtk](http://www.pdflabs.com/tools/pdftk-the-pdf-toolkit/) to your
servers to merge some documents:

1.  Check the [OpsCode
    Community](http://community.opscode.com/cookbooks) site for a
    recipe.
2.  [A recipe exists.](http://community.opscode.com/cookbooks/pdftk) You
    lucky dog.
3.  Add the recipe to your fork, push it up, and run it.
4.  It fails. Turns out they renamed the `gcj` package to `gcj-jdk`.
    Fix.
5.  It fails again. The recipe is referencing an old version of PDFtk.
    Fix.
6.  Great success.

A little bit tedious compared with `wget/tar/make`, for sure, but once
you get it configured properly, you can spin up new servers at will and
be confident that they include all the necessary software.

### Deploy hooks: learn them, love them

Chef offers a number of [deploy
callbacks](http://docs.opscode.com/resource_deploy.html#callbacks) you
can use as a stand-in for Capistrano's `before`/`after` hooks. To use
them, create a directory in your app called `deploy` and add files named
for the appropriate callbacks (e.g. `deploy/before_migrate.rb`). For
example, here's how we precompile assets before migration:

```ruby
rails_env = new_resource.environment["RAILS_ENV"]

Chef::Log.info("Precompiling assets for RAILS_ENV=#{rails_env}...")

execute "rake assets:precompile" do
  cwd release_path
  command "bundle exec rake assets:precompile"
  environment "RAILS_ENV" => rails_env
end
```

### Layers: roles, but not *dedicated* roles

AWS documentation describes
[layers](http://docs.aws.amazon.com/opsworks/latest/userguide/workinglayers.html)
as

> how to set up and configure a set of instances and related resources
> such as volumes and Elastic IP addresses.

The default layer types ("PHP App Server", "MySQL") imply that layers
distinguish separate components of your infrastructure. While that's
partially true, it's better to think about layers as the *roles* your
EC2 instances fill. For example, you might have two instances in your
"Rails App Server" role, a single, separate instance for your "Resque"
role, and one of the two app servers in the "Cron" role, responsible for
sending nightly emails.

### Altering the Rails environment

If you need to manually execute a custom recipe against your existing
instances, the Rails environment is going to be set to "production" no
matter what you've defined in the application configuration. In order to
change this value, add the following to the "Custom Chef JSON" field:

```json
{
  "deploy": {
    "app_name": {
      "rails_env": "staging"
    }
  }
}
````

(Substituting in your own application and environment names.)

------------------------------------------------------------------------

We've found OpsWorks to be a solid choice for repeatable, maintainable
server infrastructure that still offers the root access we all crave.
Certainly, it's slower out of the gate than spinning up a new Heroku app
or logging into a VPS and `apt-get`ting it up, but the investment up
front leads to a more sustainable system over time. If this sounds at
all interesting to you, seriously go check out that [introduction
post](http://artsy.github.io/blog/2013/08/27/introduction-to-aws-opsworks/).
It's the post this post wishes it was.
