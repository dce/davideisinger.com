---
title: "Backup your Database in Git"
date: 2009-05-08T00:00:00+00:00
draft: false
needs_review: true
canonical_url: https://www.viget.com/articles/backup-your-database-in-git/
---

**Short version**: dump your production database into a git repository
for an instant backup solution.

**Long version**: keeping backups of production data is fundamental for
a well-run web application, but it's tricky to maintain history while
keeping disk usage at a reasonable level. You could continually
overwrite the backup with the latest data, but you risk automatically
replacing good data with bad. You could save each version in a separate,
timestamped file, but since most of the data is static, you would end up
wasting a lot of disk space.

When you think about it, a database dump is just SQL code, so why not
manage it the same way you manage the rest of your code --- in a source
code manager? Setting such a scheme up is dead simple. On your
production server, with git installed:

    mkdir -p /path/to/backup cd /path/to/backup mysqldump -u [user] -p[pass] --skip-extended-insert [database] > [database].sql git init git add [database].sql git commit -m "Initial commit" 

The `--skip-extended-insert` option tells mysqldump to give each table
row its own `insert` statement. This creates a larger initial commit
than the default bulk insert, but makes future commits much easier to
read and (I suspect) keeps the overall repository size smaller, since
each patch only includes the individual records added/updated/deleted.

From here, all we have to do is set up a cronjob to update the backup:

    0 * * * * cd /path/to/backup && \ mysqldump -u [user] -p[pass] --skip-extended-insert [database] > [database].sql && \ git commit -am "Updating DB backup" 

You may want to add another entry to run
[`git gc`](http://www.kernel.org/pub/software/scm/git/docs/git-gc.html)
every day or so in order to keep disk space down and performance up.

Now that you have all of your data in a git repo, you've got a lot of
options. Easily view activity on your site with `git whatchanged -p`.
Update your staging server to the latest data with
`git clone ssh://[hostname]/path/to/backup`. Add a remote on
[Github](https://github.com/) and get offsite backups with a simple
`git push`.

This technique might fall down if your app approaches
[Craigslist](http://craigslist.org/)-level traffic, but it's working
flawlessly for us on [SpeakerRate](http://speakerrate.com), and should
work well for your small- to medium-sized web application.
