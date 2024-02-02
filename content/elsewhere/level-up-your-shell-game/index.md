---
title: "Level Up Your Shell Game"
date: 2013-10-24T00:00:00+00:00
draft: false
canonical_url: https://www.viget.com/articles/level-up-your-shell-game/
---

The Viget dev team was recently relaxing by the fireplace, sipping a
fine cognac out of those fancy little glasses, when the conversation
turned (as it often does) to the Unix command line. We have good systems
in place for sharing Ruby techniques ([pull request code
reviews](https://viget.com/extend/developer-ramp-up-with-pull-requests))
and [Git tips](https://viget.com/extend/a-gaggle-of-git-tips), but
everyone seemed to have a simple, useful command-line trick or two that
the rest of the team had never encountered. Here are a few of our
favorites:

-   [Keyboard
    Shortcuts](#keyboard-shortcuts)
-   [Aliases](#aliases)
-   [History
    Expansions](#history-expansions)
-   [Argument
    Expansion](#argument-expansion)
-   [Customizing
    `.inputrc`](#customizing-inputrc)
-   [Viewing Processes on a Given Port with
    `lsof`](#viewing-processes-on-a-given-port-with-lsof)
-   [SSH
    Configuration](#ssh-configuration)
-   [Invoking Remote Commands with
    SSH](#invoking-remote-commands-with-ssh)

Ready to get your {{<dither neckbeard.png "" "inline" />}} on? Good. Let's go.

## Keyboard Shortcuts

[**Mike:**](https://viget.com/about/team/mackerman) I recently
discovered a few simple Unix keyboard shortcuts that save me some time:

  Shortcut             | Result
  ---------------------|-----------------------------------------------------------------------------
  `ctrl + u`           | Deletes the portion of your command **before** the current cursor position
  `ctrl + w`           | Deletes the **word** preceding the current cursor position
  `ctrl + left arrow`  | Moves the cursor to the **left by one word**
  `ctrl + right arrow` | Moves the cursor to the **right by one word**
  `ctrl + a`           | Moves the cursor to the **beginning** of your command
  `ctrl + e`           | Moves the cursor to the **end** of your command

Thanks to [Lawson Kurtz](https://viget.com/about/team/lkurtz) for
pointing out the beginning and end shortcuts

## Aliases

[**Eli:**](https://viget.com/about/team/efatsi) Sick of typing
`bundle exec rake db:test:prepare` or other long, exhausting lines of
terminal commands? Me too. Aliases can be a big help in alleviating the
pain of typing common commands over and over again.

They can be easily created in your `~/.bash_profile` file, and have the
following syntax:

    alias gb="git branch"

I've got a whole slew of git and rails related ones that are fairly
straight-forward:

    alias ga="git add .; git add -u ."
    alias glo='git log --pretty=format:"%h%x09%an%x09%s"'
    alias gpro="git pull --rebase origin"
    ...
    alias rs="rails server"

And a few others I find useful:

    alias editcommit="git commit --amend -m"
    alias pro="cd ~/Desktop/Projects/"
    alias s.="subl ."
    alias psgrep="ps aux | grep"
    alias cov='/usr/bin/open -a "/Applications/Google Chrome.app" coverage/index.html'

If you ever notice yourself typing these things out over and over, pop
into your `.bash_profile` and whip up some of your own! If
`~/.bash_profile` is hard for you to remember like it is for me, nothing
an alias can't fix: `alias editbash="open ~/.bash_profile"`.

**Note**: you'll need to open a new Terminal window for changes in
`~/.bash_profile` to take place.

## History Expansions

[**Chris:**](https://viget.com/about/team/cjones) Here are some of my
favorite tricks for working with your history.

**`!!` - previous command**

How many times have you run a command and then immediately re-run it
with `sudo`? The answer is all the time. You could use the up arrow and
then [Mike](https://viget.com/about/team/mackerman)'s `ctrl-a` shortcut
to insert at the beginning of the line. But there's a better way: `!!`
expands to the entire previous command. Observe:

    $ rm path/to/thing
     Permission denied
    $ sudo !!
     sudo rm path/to/thing

**`!$` - last argument of the previous command**

How many times have you run a command and then run a different command
with the same argument? The answer is all the time. Don't retype it, use
`!$`:

    $ mkdir path/to/thing
    $ cd !$
     cd path/to/thing

**`!<string>` - most recent command starting with**

Here's a quick shortcut for running the most recent command that *starts
with* the provided string:

    $ rake db:migrate:reset db:seed
    $ rails s
    $ !rake # re-runs that first command

**`!<number>` - numbered command**

All of your commands are stored in `~/.bash_history`, which you can view
with the `history` command. Each entry has a number, and you can use
`!<number>` to run that specific command. Try it with `grep` to filter
for specific commands:

    $ history | grep heroku
     492 heroku run rake search:reindex -r production
     495 heroku maintenance:off -r production
     496 heroku run rails c -r production
    $ !495

This technique is perfect for an alias:

    $ alias h?="history | grep"
    $ h? heroku
     492 heroku run rake search:reindex -r production
     495 heroku maintenance:off -r production
     496 heroku run rails c -r production
    $ !495

Sweet.

## Argument Expansion

[**Ryan:**](https://viget.com/about/team/rfoster) For commands that take
multiple, similar arguments, you can use `{old,new}` to expand one
argument into two or more. For example:

    mv app/models/foo.rb app/models/foobar.rb

can be

    mv app/models/{foo,foobar}.rb

or even

    mv app/models/foo{,bar}.rb

## Customizing .inputrc

[**Brian:**](https://viget.com/about/team/blandau) One of the things I
have found to be a big time saver when using my terminal is configuring
keyboard shortcuts. Luckily if you're still using bash (which I am), you
can configure shortcuts and use them in a number of other REPLs that all
use readline. You can [configure readline keyboard shortcuts by editing
your `~/.inputrc`
file](http://cnswww.cns.cwru.edu/php/chet/readline/readline.html#SEC9).
Each line in the file defines a shortcut. It's made up of two parts, the
key sequence, and the command or macro. Here are three of my favorites:

1.  `"\ep": history-search-backward`: This will map to escape-p and will
    allow you to search for completions to the current line from your
    history. For instance, it will allow you to type "`git`" into your
    shell and then hit escape-p to cycle through all the git commands
    you have used recently looking for the correct completion.
2.  `"\t": menu-complete`: I always hated that when I tried to tab
    complete something and then I'd get a giant list of possible
    completions. By adding this line you can instead use tab to cycle
    through all the possible completions stopping on which ever one is
    the correct one.
3.  `"\C-d": kill-whole-line`: There's a built-in key command for
    killing a line after the cursor (control-k), but no way to kill the
    whole line. This solves that. After adding this to your `.inputrc`
    just type control-d from anywhere on the line and the whole line is
    gone and you're ready to start fresh.

Don't like what I mapped these commands to? Feel free to use different
keyboard shortcuts by changing that first part in quotes. There's a lot
more you can do, just check out [all the commands you can
assign](http://cnswww.cns.cwru.edu/php/chet/readline/readline.html#SEC13)
or create your own macros.

## Viewing Processes on a Given Port with lsof

[**Zachary:**](https://viget.com/about/team/zporter) When working on
projects, I occassionally need to run the application on port 80. While
I could use a tool like [Pow](http://pow.cx/) to accomplish this, I
choose to use [Passenger
Standalone](http://www.modrails.com/documentation/Users%20guide%20Standalone.html).
However, when trying to start Passenger on port 80, I will get a
response that looks something like "The address 0.0.0.0:80 is already in
use by another process". To easily view all processes communicating over
port 80, I use [`lsof`](http://linux.die.net/man/8/lsof) like so:

    sudo lsof -i :80

From here, I can pin-point who the culprit is and kill it.

## SSH Configuration

[**Patrick:**](https://viget.com/about/team/preagan) SSH is a simple
tool to use when you need shell access to a remote server. Everyone is
familiar with the most basic usage:

    $ ssh production.host

Command-line options give you control over more options such as the user
and private key file that you use to authenticate:

    $ ssh -l www-data -i /Users/preagan/.ssh/viget production.host

However, managing these options with the command-line is tedious if you
use different private keys for work-related and personal servers. This
is where your local `.ssh/config` file can help -- by specifying the
host that you connect to, you can set specific options for that
connection:

    # ~/.ssh/config
    Host production.host
     User www-data
     IdentityFile /Users/preagan/.ssh/viget

Now, simply running `ssh production.host` will use the correct username
and private key when authenticating. Additionally, services that use SSH
as the underlying transport mechanism will honor these settings -- you
can use this with Github to send an alternate private key just as
easily:

    Host github.com
     IdentityFile /Users/preagan/.ssh/github

**Bonus Tip**

This isn't limited to just setting host-specific options, you can also
use this configuration file to create quick aliases for hosts that
aren't addressable by DNS:

    Host prod
     Hostname 192.168.1.1
     Port 6000
     User www-data
     IdentityFile /Users/preagan/.ssh/production-key

All you need to do is run `ssh prod` and you're good to go. For more
information on what settings are available, check out the manual
([`man ssh_config`](http://linux.die.net/man/5/ssh_config)).

## Invoking Remote Commands with SSH

[**David**:](https://viget.com/about/team/deisinger) You're already
using SSH to launch interactive sessions on your remote servers, but DID
YOU KNOW you can also pass the commands you want to run to the `ssh`
program and use the output just like you would a local operation? For
example, if you want to pull down a production database dump, you could:

1.  `ssh` into your production server
2.  Run `mysqldump` to generate the data dump
3.  Run `gzip` to create a compressed file
4.  Log out
5.  Use `scp` to grab the file off the remote server

Or! You could use this here one-liner:

    ssh user@host.com "mysqldump -u db_user -h db_host -pdb_password db_name | gzip" > production.sql.gz

Rather than starting an interactive shell, you're logging in, running
the `mysqldump` command, piping the result into `gzip`, and then taking
the result and writing it to a local file. From there, you could chain
on decompressing the file, importing it into your local database, etc.

**Bonus tip:** store long commands like this in
[boom](https://github.com/holman/boom) for easy recall.

------------------------------------------------------------------------

Well, that's all we've got for you. Hope you picked up something useful
along the way. What are your go-to command line tricks? Let us know in
the comments.
