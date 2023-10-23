---
title: "Let’s Write a Dang ElasticSearch Plugin"
date: 2021-03-15T00:00:00+00:00
draft: false
needs_review: true
canonical_url: https://www.viget.com/articles/lets-write-a-dang-elasticsearch-plugin/
---

One of our current projects involves a complex interactive query builder
to search a large collection of news items. Some of the conditionals
fall outside of the sweet spot of Postgres (e.g. word X must appear
within Y words of word Z), and so we opted to pull in
[ElasticSearch](https://www.elastic.co/elasticsearch/) alongside it.
It\'s worked perfectly, hitting all of our condition and grouping needs
with one exception: we need to be able to filter for articles that
contain a term a minimum number of times (so \"Apple\" must appear in
the article 3 times, for example). Frustratingly, Elastic *totally* has
this information via its
[`term_vector`](https://www.elastic.co/guide/en/elasticsearch/reference/current/term-vector.html)
feature, but you can\'t use that data inside a query, as least as far as
I can tell.

The solution, it seems, is to write a custom plugin. I figured it out,
eventually, but it was a lot of trial-and-error as the documentation I
was able to find is largely outdated or incomplete. So I figured I\'d
take what I learned while it\'s still fresh in my mind in the hopes that
someone else might have an easier time of it. That\'s what internet
friends are for, after all.

Quick note before we start: all the version numbers you see are current
and working as of February 25, 2021. Hopefully this post ages well, but
if you try this out and hit issues, bumping the versions of Elastic,
Gradle, and maybe even Java is probably a good place to start. Also, I
use `projectname` a lot in the code examples --- that\'s not a special
word and you should change it to something that makes sense for you.

[]{#1-set-up-a-java-development-environment}

## 1. Set up a Java development environment [\#](#1-set-up-a-java-development-environment "Direct link to 1. Set up a Java development environment"){.anchor aria-label="Direct link to 1. Set up a Java development environment"}

First off, you\'re gonna be writing some Java. That\'s not my usual
thing, so the first step was to get a working environment to compile my
code. To do that, we\'ll use [Docker](https://www.docker.com/). Here\'s
a `Dockerfile`:

``` {.code-block .line-numbers}
FROM adoptopenjdk/openjdk12:jdk-12.0.2_10-ubuntu

RUN apt-get update && 
  apt-get install -y zip unzip && 
  rm -rf /var/lib/apt/lists/*

SHELL ["/bin/bash", "-c"]

RUN curl -s "https://get.sdkman.io" | bash && 
  source "/root/.sdkman/bin/sdkman-init.sh" && 
  sdk install gradle 6.8.2

WORKDIR /plugin
```

We use a base image with all the Java stuff but also a working Ubuntu
install so that we can do normal Linux-y things inside our container.
From your terminal, build the image:

`> docker build . -t projectname-java`

Then, spin up the container and start an interactive shell, mounting
your local working directory into `/plugin`:

`> docker run --rm -it -v ${PWD}:/plugin projectname-java bash`

[]{#2-configure-gradle}

## 2. Configure Gradle [\#](#2-configure-gradle "Direct link to 2. Configure Gradle"){.anchor aria-label="Direct link to 2. Configure Gradle"}

[Gradle](https://gradle.org/) is a \"build automation tool for
multi-language software development,\" and what Elastic recommends for
plugin development. Configuring Gradle to build the plugin properly was
the hardest part of this whole endeavor. Throw this into `build.gradle`
in your project root:

``` {.code-block .line-numbers}
buildscript {
  repositories {
    mavenLocal()
    mavenCentral()
    jcenter()
  }

  dependencies {
    classpath "org.elasticsearch.gradle:build-tools:7.11.1"
  }
}

apply plugin: 'java'

compileJava {
  sourceCompatibility = JavaVersion.VERSION_12
  targetCompatibility = JavaVersion.VERSION_12
}

apply plugin: 'elasticsearch.esplugin'

group = "com.projectname"
version = "0.0.1"

esplugin {
  name 'contains-multiple'
  description 'A script for finding documents that match a term a certain number of times'
  classname 'com.projectname.containsmultiple.ContainsMultiplePlugin'
  licenseFile rootProject.file('LICENSE.txt')
  noticeFile rootProject.file('NOTICE.txt')
}

validateNebulaPom.enabled = false
```

You\'ll also need files named `LICENSE.txt` and `NOTICE.txt` --- mine
are empty, since the plugin is for internal use only. If you\'re going
to be releasing your plugin in some public way, maybe talk to a lawyer
about what to put in those files.

[]{#3-write-the-dang-plugin}

## 3. Write the dang plugin [\#](#3-write-the-dang-plugin "Direct link to 3. Write the dang plugin"){.anchor aria-label="Direct link to 3. Write the dang plugin"}

To write the actual plugin, I started with [this example
plugin](https://github.com/elastic/elasticsearch/blob/master/plugins/examples/script-expert-scoring/src/main/java/org/elasticsearch/example/expertscript/ExpertScriptPlugin.java)
which scores a document based on the frequency of a given term. My use
case was fortunately quite similar, though I\'m using a `filter` query,
meaning I just want a boolean, i.e. does this document contain this term
the requisite number of times? As such, I implemented a
[`FilterScript`](https://www.javadoc.io/doc/org.elasticsearch/elasticsearch/latest/org/elasticsearch/script/FilterScript.html)
rather than the `ScoreScript` implemented in the example code.

This file lives in (deep breath)
`src/main/java/com/projectname/containsmultiple/ContainsMultiplePlugin.java`:

``` {.code-block .line-numbers}
package com.projectname.containsmultiple;

import org.apache.lucene.index.LeafReaderContext;
import org.apache.lucene.index.PostingsEnum;
import org.apache.lucene.index.Term;
import org.elasticsearch.common.settings.Settings;
import org.elasticsearch.plugins.Plugin;
import org.elasticsearch.plugins.ScriptPlugin;
import org.elasticsearch.script.FilterScript;
import org.elasticsearch.script.FilterScript.LeafFactory;
import org.elasticsearch.script.ScriptContext;
import org.elasticsearch.script.ScriptEngine;
import org.elasticsearch.script.ScriptFactory;
import org.elasticsearch.search.lookup.SearchLookup;

import java.io.IOException;
import java.io.UncheckedIOException;
import java.util.Collection;
import java.util.Map;
import java.util.Set;

/**
 * A script for finding documents that match a term a certain number of times
 */
public class ContainsMultiplePlugin extends Plugin implements ScriptPlugin {

    @Override
    public ScriptEngine getScriptEngine(
        Settings settings,
        Collection<ScriptContext<?>> contexts
    ) {
        return new ContainsMultipleEngine();
    }

    // tag::contains_multiple
    private static class ContainsMultipleEngine implements ScriptEngine {
        @Override
        public String getType() {
            return "expert_scripts";
        }

        @Override
        public <T> T compile(
            String scriptName,
            String scriptSource,
            ScriptContext<T> context,
            Map<String, String> params
        ) {
            if (context.equals(FilterScript.CONTEXT) == false) {
                throw new IllegalArgumentException(getType()
                        + " scripts cannot be used for context ["
                        + context.name + "]");
            }
            // we use the script "source" as the script identifier
            if ("contains_multiple".equals(scriptSource)) {
                FilterScript.Factory factory = new ContainsMultipleFactory();
                return context.factoryClazz.cast(factory);
            }
            throw new IllegalArgumentException("Unknown script name "
                    + scriptSource);
        }

        @Override
        public void close() {
            // optionally close resources
        }

        @Override
        public Set<ScriptContext<?>> getSupportedContexts() {
            return Set.of(FilterScript.CONTEXT);
        }

        private static class ContainsMultipleFactory implements FilterScript.Factory,
                                                      ScriptFactory {
            @Override
            public boolean isResultDeterministic() {
                return true;
            }

            @Override
            public LeafFactory newFactory(
                Map<String, Object> params,
                SearchLookup lookup
            ) {
                return new ContainsMultipleLeafFactory(params, lookup);
            }
        }

        private static class ContainsMultipleLeafFactory implements LeafFactory {
            private final Map<String, Object> params;
            private final SearchLookup lookup;
            private final String field;
            private final String term;
            private final int count;

            private ContainsMultipleLeafFactory(
                        Map<String, Object> params, SearchLookup lookup) {
                if (params.containsKey("field") == false) {
                    throw new IllegalArgumentException(
                            "Missing parameter [field]");
                }
                if (params.containsKey("term") == false) {
                    throw new IllegalArgumentException(
                            "Missing parameter [term]");
                }
                if (params.containsKey("count") == false) {
                    throw new IllegalArgumentException(
                            "Missing parameter [count]");
                }
                this.params = params;
                this.lookup = lookup;
                field = params.get("field").toString();
                term = params.get("term").toString();
                count = Integer.parseInt(params.get("count").toString());
            }

            @Override
            public FilterScript newInstance(LeafReaderContext context)
                    throws IOException {
                PostingsEnum postings = context.reader().postings(
                        new Term(field, term));
                if (postings == null) {
                    /*
                     * the field and/or term don't exist in this segment,
                     * so always return 0
                     */
                    return new FilterScript(params, lookup, context) {
                        @Override
                        public boolean execute() {
                            return false;
                        }
                    };
                }
                return new FilterScript(params, lookup, context) {
                    int currentDocid = -1;
                    @Override
                    public void setDocument(int docid) {
                        /*
                         * advance has undefined behavior calling with
                         * a docid <= its current docid
                         */
                        if (postings.docID() < docid) {
                            try {
                                postings.advance(docid);
                            } catch (IOException e) {
                                throw new UncheckedIOException(e);
                            }
                        }
                        currentDocid = docid;
                    }
                    @Override
                    public boolean execute() {
                        if (postings.docID() != currentDocid) {
                            /*
                             * advance moved past the current doc, so this
                             * doc has no occurrences of the term
                             */
                            return false;
                        }
                        try {
                            return postings.freq() >= count;
                        } catch (IOException e) {
                            throw new UncheckedIOException(e);
                        }
                    }
                };
            }
        }
    }
    // end::contains_multiple
}
```

[]{#4-add-it-to-elasticSearch}

## 4. Add it to ElasticSearch [\#](#4-add-it-to-elasticSearch "Direct link to 4. Add it to ElasticSearch"){.anchor aria-label="Direct link to 4. Add it to ElasticSearch"}

With our code in place (and synced into our Docker container with a
mounted volume), it\'s time to compile it. In the Docker shell you
started up in step #1, build your plugin:

`> gradle build`

Assuming that works, you should now see a `build` directory with a bunch
of stuff in it. The file you care about is
`build/distributions/contains-multiple-0.0.1.zip` (though that\'ll
obviously change if you call your plugin something different or give it
a different version number). Grab that file and copy it to where you
plan to actually run ElasticSearch. For me, I placed it in a folder
called `.docker/elastic` in the main project repo. In that same
directory, create a new `Dockerfile` that\'ll actually run Elastic:

``` {.code-block .line-numbers}
FROM docker.elastic.co/elasticsearch/elasticsearch:7.11.1

COPY .docker/elastic/contains-multiple-0.0.1.zip /plugins/contains-multiple-0.0.1.zip

RUN elasticsearch-plugin install 
  file:///plugins/contains-multiple-0.0.1.zip
```

Then, in your project root, create the following `docker-compose.yml`:

``` {.code-block .line-numbers}
version: '3.2'

services: elasticsearch:
    image: projectname_elasticsearch
    build:
      context: .
      dockerfile: ./.docker/elastic/Dockerfile
      ports:
        - 9200:9200
      environment:
        - discovery.type=single-node
        - script.allowed_types=inline
        - script.allowed_contexts=filter
```

Those last couple lines are pretty important and your script won\'t work
without them. Build your image with `docker-compose build` and then
start Elastic with `docker-compose up`.

[]{#5-use-your-plugin}

## 5. Use your plugin [\#](#5-use-your-plugin "Direct link to 5. Use your plugin"){.anchor aria-label="Direct link to 5. Use your plugin"}

To actually see the plugin in action, first create an index and add some
documents (I\'ll assume you\'re able to do this if you\'ve read this far
into this post). Then, make a query with `curl` (or your Elastic wrapper
of choice), substituting `full_text`, `yabba` and `index_name` with
whatever makes sense for you:

``` {.code-block .line-numbers}
> curl -H "content-type: application/json" 
-d '
{
  "query": {
    "bool": {
      "filter": {
        "script": {
          "script": {
            "source": "contains_multiple",
            "lang": "expert_scripts",
            "params": {
              "field": "full_text",
              "term": "yabba",
              "count": 3
            }
          }
        }
      }
    }
  }
}' 
"localhost:9200/index_name/_search?pretty"
```

The result should be something like:

``` {.code-block .line-numbers}
{
  "took" : 6,
  "timed_out" : false,
  "_shards" : {
    "total" : 1,
    "successful" : 1,
    "skipped" : 0,
    "failed" : 0
  },
  "hits" : {
    "total" : {
      "value" : 1,
      "relation" : "eq"
    },
    "max_score" : 0.0,
    "hits" : [
      {
        "_index" : "index_name",
        "_type" : "_doc",
        "_id" : "10",
        ...
```

So that\'s that, an ElasticSearch plugin from start-to-finish. I\'m sure
there are better ways to do some of this stuff, and if you\'re aware of
any, let us know in the comments or write your own dang blog.
