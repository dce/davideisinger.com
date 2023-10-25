---
title: "Local Docker Best Practices"
date: 2022-05-05T00:00:00+00:00
draft: false
canonical_url: https://www.viget.com/articles/local-docker-best-practices/
featured: true
---

Here at Viget, Docker has become an indispensable tool for local
development. We build and maintain a ton of apps across the team,
running different stacks and versions, and being able to package up a
working dev environment makes it much, much easier to switch between
apps and ramp up new devs onto projects. That's not to say that
developing with Docker locally isn't without its
drawbacks[^1], but
they're massively outweighed by the ease and convenience it unlocks.

Over time, we've developed our own set of best practices for effectively
setting Docker up for local development. Please note that last bit ("for
local development") -- if you're creating images for deployment
purposes, most of these principles don't apply. Our typical setup
involves the following containers, orchestrated with Docker Compose:

1.  The application (e.g. Rails, Django, or Phoenix)
2.  A JavaScript watcher/compiler (e.g. `webpack-dev-server`)
3.  A database (typically PostgreSQL)
4.  Additional necessary infrastructure (e.g. Redis, ElasticSearch,
    Mailhog)
5.  Occasionally, additional instances of the app doing things other
    than running the development server (think background jobs)

So with that architecture in mind, here are the best practices we've
tried to standardize on:

1.  [Don't put code or app-level dependencies into the
    image](#1-dont-put-code-or-app-level-dependencies-into-the-image)
2.  [Don't use a Dockerfile if you don't have
    to](#2-dont-use-a-dockerfile-if-you-dont-have-to)
3.  [Only reference a Dockerfile once in
    `docker-compose.yml`](#3-only-reference-a-dockerfile-once-in-docker-composeyml)
4.  [Cache dependencies in named
    volumes](#4-cache-dependencies-in-named-volumes)
5.  [Put ephemeral stuff in named
    volumes](#5-put-ephemeral-stuff-in-named-volumes)
6.  [Clean up after `apt-get update`](#6-clean-up-after-apt-get-update)
7.  [Prefer `exec` to `run`](#7-prefer-exec-to-run)
8.  [Coordinate services with
    `wait-for-it`](#8-coordinate-services-with-wait-for-it)
9.  [Start entrypoint scripts with `set -e` and end with
    `exec "$@"`](#9-start-entrypoint-scripts-with-set--e-and-end-with-exec-)
10. [Target different CPU architectures with
    `BUILDARCH`](#10-target-different-cpu-architectures-with-buildarch)
11. [Prefer `docker compose` to
    `docker-compose`](#11-prefer-docker-compose-to-docker-compose)

------------------------------------------------------------------------

### 1. Don't put code or app-level dependencies into the image

Your primary Dockerfile, the one the application runs in, should include
all the necessary software to run the app, but shouldn't include the
actual application code itself -- that'll be mounted into the container
when `docker-compose run` starts and synced between the container and
the local machine.

Additionally, it's important to distinguish between system-level
dependencies (like ImageMagick) and application-level ones (like
Rubygems and NPM packages) -- the former should be included in the
Dockerfile; the latter should not. Baking application-level dependencies
into the image means that it'll have to be rebuilt every time someone
adds a new one, which is both time-consuming and error-prone. Instead,
we install those dependencies as part of a startup script.

### 2. Don't use a Dockerfile if you don't have to

With point #1 in mind, you might find you don't need to write a
Dockerfile at all. If your app doesn't have any special dependencies,
you might be able to point your `docker-compose.yml` entry right at the
official Docker repository (i.e. just reference `ruby:2.7.6`). This
isn't very common -- most apps and frameworks require some amount of
infrastructure (e.g. Rails needs a working version of Node), but if you
find yourself with a Dockerfile that contains just a single `FROM` line,
you can just cut it.

### 3. Only reference a Dockerfile once in `docker-compose.yml`

If you're using the same image for multiple services (which you
should!), only provide the build instructions in the definition of a
single service, assign a name to it, and then reference that name for
the additional services. So as an example, imagine a Rails app that uses
a shared image for running the development server and
`webpack-dev-server`. An example configuration might look like this:

```yaml
services:
  rails:
    image: appname_rails
    build:
      context: .
      dockerfile: ./.docker-config/rails/Dockerfile
    command: ./bin/rails server -p 3000 -b '0.0.0.0'

  node:
    image: appname_rails
    command: ./bin/webpack-dev-server
```

This way, when we build the services (with `docker-compose build`), our
image only gets built once. If instead we'd omitted the `image:`
directives and duplicated the `build:` one, we'd be rebuilding the exact
same image twice, wasting your disk space and limited time on this
earth.

### 4. Cache dependencies in named volumes

As mentioned in point #1, we don't bake code dependencies into the image
and instead install them on startup. As you can imagine, this would be
pretty slow if we installed every gem/pip/yarn library from scratch each
time we restarted the services (hello NOKOGIRI), so we use Docker's
named volumes to keep a cache. The config above might become something
like:

```yaml
volumes:
  gems:
  yarn:

services:
  rails:
    image: appname_rails
    build:
      context: .
      dockerfile: ./.docker-config/rails/Dockerfile
    command: ./bin/rails server -p 3000 -b '0.0.0.0'
    volumes:
      - .:/app
      - gems:/usr/local/bundle
      - yarn:/app/node_modules

  node:
    image: appname_rails
    command: ./bin/webpack-dev-server
    volumes:
      - .:/app
      - yarn:/app/node_modules
```

Where specifically you should mount the volumes to will vary by stack,
but the same principle applies: keep the compiled dependencies in named
volumes to massively decrease startup time.

### 5. Put ephemeral stuff in named volumes

While we're on the subject of using named volumes to increase
performance, here's another hot tip: put directories that hold files you
don't need to edit into named volumes to stop them from being synced
back to your local machine (which carries a big performance cost). I'm
thinking specifically of `log` and `tmp` directories, in addition to
wherever your app stores uploaded files. A good rule of thumb is, if
it's `.gitignore`'d, it's a good candidate for a volume.

### 6. Clean up after `apt-get update`

If you use Debian-based images as the starting point for your
Dockerfiles, you've noticed that you have to run `apt-get update` before
you're able to `apt-get install` your dependencies. If you don't take
precautions, this is going to cause a bunch of additional data to get
baked into your image, drastically increasing its size. Best practice is
to do the update, install, and cleanup in a single `RUN` command:

```dockerfile
RUN apt-get update &&
  apt-get install -y libgirepository1.0-dev libpoppler-glib-dev &&
  rm -rf /var/lib/apt/lists/*
```

### 7. Prefer `exec` to `run`

If you need to run a command inside a container, you have two options:
`run` and `exec`. The former is going to spin up a new container to run
the command, while the latter attaches to an existing running container.

In almost every instance, assuming you pretty much always have the
services running while you're working on the app, `exec` (and
specifically `docker-compose exec`) is what you want. It's faster to
spin up and doesn't carry any chance of leaving weird artifacts around
(which will happen if you're not careful about including the `--rm` flag
with `run`).

### 8. Coordinate services with `wait-for-it`

Given our dependence on shared images and volumes, you may encounter
issues where one of your services starts before another service's
`entrypoint` script finishes executing, leading to errors. When this
occurs, we'll pull in the [`wait-for-it` utility
script](https://github.com/vishnubob/wait-for-it), which takes a web
location to check against and a command to run once that location sends
back a response. Then we update our `docker-compose.yml` to use it:

```yaml
volumes:
  gems:
  yarn:

services:
  rails:
    image: appname_rails
    build:
      context: .
      dockerfile: ./.docker-config/rails/Dockerfile
    command: ./bin/rails server -p 3000 -b '0.0.0.0'
    volumes:
      - .:/app
      - gems:/usr/local/bundle
      - yarn:/app/node_modules

  node:
    image: appname_rails
    command: [
      "./.docker-config/wait-for-it.sh",
      "rails:3000",
      "--timeout=0",
      "--",
      "./bin/webpack-dev-server"
    ]
    volumes:
      - .:/app
      - yarn:/app/node_modules
```

This way, `webpack-dev-server` won't start until the Rails development
server is fully up and running.

### 9. Start entrypoint scripts with `set -e` and end with `exec "$@"`

The setup we've described here depends a lot on using
[entrypoint](https://docs.docker.com/compose/compose-file/#entrypoint)
scripts to install dependencies and manage other setup. There are two
things you should include in **every single one** of these scripts, one
at the beginning, one at the end:

-   At the top of the file, right after `#!/bin/bash` (or similar), put
    `set -e`. This will ensure that the script exits if any line exits
    with an error.
-   At the end of the file, put `exec "$@"`. Without this, the
    instructions you pass in with the
    [command](https://docs.docker.com/compose/compose-file/#command)
    directive won't execute.

[Here's a good StackOverflow
answer](https://stackoverflow.com/a/48096779) with some more
information.

### 10. Target different CPU architectures with `BUILDARCH`

We're presently about evenly split between Intel and Apple Silicon
laptops. Most of the common base images you pull from
[DockerHub](https://hub.docker.com/) are multi-platform (for example,
look at the "OS/Arch" dropdown for the [Ruby
image](https://hub.docker.com/layers/library/ruby/2.7.6/images/sha256-1af3ca0ab535007d18f7bc183cc49c228729fc10799ba974fbd385889e4d658a?context=explore)),
and Docker will pull the correct image for the local architecture.
However, if you're doing anything architecture-specific in your
Dockerfiles, you might encounter difficulties.

As mentioned previously, we'll often need a specific version of Node.js
running inside a Ruby-based image. A way we'd commonly set this up is
something like this:

```dockerfile
FROM ruby:2.7.6

RUN curl -sS https://nodejs.org/download/release/v16.17.0/node-v16.17.0-linux-x64.tar.gz
    | tar xzf - --strip-components=1 -C "/usr/local"
```

This works fine on Intel Macs, but blows up on Apple Silicon -- notice
the `x64` in the above URL? That needs to be `arm64` on an M1. The
easiest option is to specify `platform: linux/amd64` for each service
using this image in your `docker-compose.yml`, but that's going to put
Docker into emulation mode, which has performance drawbacks as well as
[other known
issues](https://docs.docker.com/desktop/mac/apple-silicon/#known-issues).

Fortunately, Docker exposes a handful of [platform-related
arguments](https://docs.docker.com/engine/reference/builder/#automatic-platform-args-in-the-global-scope)
we can lean on to target specific architectures. We'll use `BUILDARCH`,
the architecture of the local machine. While there's no native
conditional functionality in the Dockerfile spec, we can do a little bit
of shell scripting inside of a `RUN` command to achieve the desired
result:

```dockerfile
FROM ruby:2.7.6

ARG BUILDARCH

RUN if [ "$BUILDARCH" = "arm64" ];
  then curl -sS https://nodejs.org/download/release/v16.17.0/node-v16.17.0-linux-arm64.tar.gz
    | tar xzf - --strip-components=1 -C "/usr/local";
  else curl -sS https://nodejs.org/download/release/v16.17.0/node-v16.17.0-linux-x64.tar.gz
    | tar xzf - --strip-components=1 -C "/usr/local";
  fi
```

This way, a dev running on Apple Silicon will download and install
`node-v16.17.0-linux-arm64`, and someone with Intel will use
`node-v16.17.0-linux-x64`.

### 11. Prefer `docker compose` to `docker-compose`

Though both `docker compose up` and `docker-compose up` (with or without
a hyphen) work to spin up your containers, per this [helpful
StackOverflow answer](https://stackoverflow.com/a/66516826),
"`docker compose` (with a space) is a newer project to migrate compose
to Go with the rest of the docker project."

*Thanks [Dylan](https://www.viget.com/about/team/dlederle-ensign/) for
this one.*

---

So there you have it, a short list of the best practices we've developed
over the last several years of working with Docker. We'll try to keep
this list updated as we get better at doing and documenting this stuff.

If you're interested in reading more, here are a few good links:

-   [Ruby on Whales: Dockerizing Ruby and Rails
    development](https://evilmartians.com/chronicles/ruby-on-whales-docker-for-ruby-rails-development)
-   [Docker: Right for Us. Right for
    You?](https://www.viget.com/articles/docker-right-for-us-right-for-you-1/)
-   [Docker + Rails: Solutions to Common
    Hurdles](https://www.viget.com/articles/docker-rails-solutions-to-common-hurdles/)

[^1]: Namely, there's a significant performance hit when running Docker
on Mac (as we do) in addition to the cognitive hurdle of all your
stuff running inside containers. If I worked at a product shop,
where I was focused on a single codebase for the bulk of my time,
I'd think hard before going all in on local
Docker.
