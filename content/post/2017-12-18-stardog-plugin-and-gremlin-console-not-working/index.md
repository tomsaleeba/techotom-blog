---
author: Tom Saleeba
date: "2017-12-18T00:00:00Z"
summary: You've followed the instructions to install the plugin and it doesn't load,
  now what?
tags:
- stardog
- gremlin
- tinkerpop
title: Stardog plugin and Gremlin console not working
---
# TL;DR
Newer versions of Gremlin console don't seem to work with Stardog 5.1.0. Go back to `3.0.2-incubating` for Gremlin console. This is the version that the Stardog docs link to at the time of writing.

# Background
Firstly, dates and versions will be important here. Note the publish date of the post (December 2017) and I'm using Gremlin console 3.3.0 (well, started with this version) and Stardog 5.1.0.

I've been trying to test the Gremlin console against Stardog by following the instructions at [https://www.stardog.com/docs/#_stardog_gremlin_console](). The problem is the plugin doesn't get loaded by Gremlin console, which you can see in the following:
```bash
$ ./bin/gremlin.sh # version 3.3.0

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

Eventually I realised the Stardog docs were linking to an earlier version of Gremlin console so I tried going back to older versions. Versions `3.2.6` and `3.1.8` loaded the plugin, which is a better start. They both threw stacktraces when I tried to connect to Stardog however. As a reference, here's what I got:
```bash
# version 3.2.6
gremlin> graph = StardogGraphFactory.open(graphConf.build())
Could not initialize class com.complexible.stardog.gremlin.structure.CachedStardogGraph
Type ':help' or ':h' for help.
Display stack trace? [yN]y
java.lang.NoClassDefFoundError: Could not initialize class com.complexible.stardog.gremlin.structure.CachedStardogGraph
        at com.complexible.stardog.gremlin.StardogGraphFactory.open(StardogGraphFactory.java:33)
        at com.complexible.stardog.gremlin.StardogGraphFactory$open.call(Unknown Source)
        at org.codehaus.groovy.runtime.callsite.CallSiteArray.defaultCall(CallSiteArray.java:48)
        ...
```

```bash
# version 3.1.8
gremlin> graph = StardogGraphFactory.open(graphConf.build())
org/apache/tinkerpop/gremlin/process/traversal/TraversalStrategy$VendorOptimizationStrategy
Display stack trace? [yN] y
java.lang.NoClassDefFoundError: org/apache/tinkerpop/gremlin/process/traversal/TraversalStrategy$VendorOptimizationStrategy
        at java.lang.ClassLoader.defineClass1(Native Method)
        at java.lang.ClassLoader.defineClass(ClassLoader.java:763)
        at java.security.SecureClassLoader.defineClass(SecureClassLoader.java:142)
        ...
Caused by: java.lang.ClassNotFoundException: org.apache.tinkerpop.gremlin.process.traversal.TraversalStrategy$VendorOptimizationStrategy
        at java.net.URLClassLoader.findClass(URLClassLoader.java:381)
        ...
```

# The solution
This is a simple one, go back to the version of Gremlin console that Stardog links to in their docs. That's version `3.0.2-incubating`. Most Apache mirrors have stopped hosting `3.0.x` versions but you can still get it at [https://archive.apache.org/dist/incubator/tinkerpop/3.0.2-incubating/apache-gremlin-console-3.0.2-incubating-bin.zip](). It's worth noting that the syntax for the console commands to traverse the graph have changed so refer to the older doco too [https://tinkerpop.apache.org/docs/3.0.2-incubating/#addvertex-step]().

After unpacking the `3.0.2-incubating` console, follow the Stardog instructions to install the plugin. Then start the console and you should see the `complexible.stardog` plugin listed like expected:
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
gremlin> :pin use complexible.stardog
==>complexible.stardog activated
```

Then you can connect to your Stardog server and run a query (make sure `mygraph` DB exists on Stardog first):
```groovy
graphConf = StardogGraphConfiguration.builder()
graphConf.connectionString("http://localhost:5820/mygraph").credentials("admin", "admin").baseIRI("http://tinkerpop.incubator.apache.org/")
graph = StardogGraphFactory.open(graphConf.build())
g = graph.traversal()
// create some verticies
g.addV('name', 'Alice')
g.addV('name', 'Bob')
// add an edge
g.withSideEffect('a', g.V().has('name', 'Alice')).V().has('name', 'Bob').addOutE('knows', 'a')
// get the name of the person that Bob knows
g.V().has('name', 'Bob').out('knows').properties('name').value()
// commit the changes so you can see them with Stardog SPARQL
graph.tx().commit()
```

If you then open a SPARQL query window for Stardog, you can run a query to see the triples that you've created via the Gremlin console:
```sparql
SELECT *
WHERE {
  ?s ?p ?o .
}
```
{{< figure src="stardog-sparql-result.jpg" alt="result of SPARQL query" >}}
