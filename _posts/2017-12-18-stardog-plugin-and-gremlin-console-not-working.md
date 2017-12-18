---
layout: post
title: Stardog plugin and Gremlin console not working
author: Tom Saleeba
tags:
  - stardog
  - gremlin
  - tinkerpop
excerpt: You've followed the instructions to install the plugin and it doesn't load, now what?
---
# TL;DR
Version 3.3.0 of Gremlin console doesn't seem to work with Stardog 5.1.0. Go back to 3.2.x for Gremlin console. I had success using the latest at the time of writing, version 3.2.6.

# Background
Firstly, dates and versions will be important here. Note the publish date of the post (December 2017) and I'm using Gremlin console 3.3.0 and Stardog 5.1.0.

I've been trying to test the Gremlin console against Stardog by following the instructions at [https://www.stardog.com/docs/#_stardog_gremlin_console](). The problem is the plugin doesn't get loaded by Gremlin console, which you can see in the following:
```bash
$ ./bin/gremlin.sh

         \,,,/
         (o o)
-----oOOo-(3)-oOOo-----
plugin activated: tinkerpop.server
plugin activated: tinkerpop.utilities
plugin activated: tinkerpop.tinkergraph
gremlin> :pin list
==>tinkerpop.server[active]
==>tinkerpop.gephi
==>tinkerpop.utilities[active]
==>tinkerpop.sugar
==>tinkerpop.credentials
==>tinkerpop.tinkergraph[active]
```

My Google-fu must be weak because I didn't turn up much information on Gremlin plugins in general let alone the Stardog one specifically. It's my hope that this post will show up for searches like I was doing: "gremlin stardog plugin", "gremlin plugin" or "gremlin plugin loading".

# The solution
This is a simple one, go back to an earlier minor release of Gremlin console. For me, going back to 3.2.6 was a success. Here's a link to the Apache mirror listing for 3.2.6 https://www.apache.org/dyn/closer.lua/tinkerpop/3.2.6/apache-tinkerpop-gremlin-console-3.2.6-bin.zip.

After unpacking the 3.2.x console, following the Stardog instructions to install the plugin and firing the console up, you could see the `complexible.stardog` plugin like expected:
```bash
$ ./bin/gremlin.sh

         \,,,/
         (o o)
-----oOOo-(3)-oOOo-----
plugin activated: tinkerpop.server
plugin activated: tinkerpop.utilities
plugin activated: tinkerpop.tinkergraph
gremlin> :pin list
==>tinkerpop.server[active]
==>tinkerpop.gephi
==>tinkerpop.utilities[active]
==>tinkerpop.sugar
==>tinkerpop.credentials
==>complexible.stardog
==>tinkerpop.tinkergraph[active]
```

It might be worth mentioning that at the time of writing, the Stardog docs point to version 3.0.2-incubating of the Gremlin console: http://tinkerpop.incubator.apache.org/docs/3.0.2-incubating/#gremlin-console. Turns out you don't have to go back quite that far to get support though.
