---
categories:
- Software Development
date: "2016-03-17T06:32:56Z"
title: Loading TDB data into Apache Fuseki
aliases:
- /software development/2016/03/17/loading-tdb-data-into-apache-fuseki.html
---
# Background

I'm working with Apache Jena and Apache Fuseki (v2.3.1) at the moment and today I had the need to load more than one lot of data into Fuseki on start up. I thought I needed an assembler file, and I probably could've used one, but I've ended up using config file for Fuseki.

I was Googling for 'example Fuseki config files' to get up and running quickly but didn't find anything so it's my hope that others can use this blog post to get a TDB data directory loaded into Fuseki using a config file quickly.

All the information was found here: [https://jena.apache.org/documentation/serving_data/#fuseki-configuration-file]() but there's not just one whole example that you can copy-paste to get going. You need to read it all and pull the relevant pieces out. RTFM is a good thing, I know, but sometimes we just want to get something running to keep that feedback loop short.

# The config file (assembler.ttl)

The first thing you want to change is the value of the `tdb:location` property in the `<#dataset>` entity at the bottom. This should be the path to the TDB data directory on your file system.

```sparql
@prefix fuseki:  .
@prefix rdf:  .
@prefix rdfs:  .
@prefix tdb:  .
@prefix ja:  .
@prefix : <#> .

[] rdf:type fuseki:Server ;
# Server-wide context parameters can be given here.
# For example, to set query timeouts: on a server-wide basis:
# Format 1: "1000" -- 1 second timeout
# Format 2: "10000,60000" -- 10s timeout to first result, then 60s timeout to for rest of query.
# See java doc for ARQ.queryTimeout
# ja:context [ ja:cxtName "arq:queryTimeout" ; ja:cxtValue "10000" ] ;

# Load custom code (rarely needed)
# ja:loadClass "your.code.Class" ;

# Services available. Only explicitly listed services are configured.
# If there is a service description not linked from this list, it is ignored.
fuseki:services (
  <#service1>
) .

# Declaration additional assembler items.
[] ja:loadClass "org.apache.jena.tdb.TDB" .

# TDB
tdb:DatasetTDB rdfs:subClassOf ja:RDFDataset .
tdb:GraphTDB rdfs:subClassOf ja:Model .

<#service1> rdf:type fuseki:Service ;
fuseki:name "tdb" ; # http://host:port/tdb
fuseki:serviceQuery "sparql" ; # SPARQL query service
fuseki:dataset <#dataset> ;
.

<#dataset> rdf:type tdb:DatasetTDB ;
tdb:location <span style="color:#ff0000;">"/home/ubuntu/rdf/tdb-data/"</span> ;
# Query timeout on this dataset (1s, 1000 milliseconds)
ja:context [ ja:cxtName "arq:queryTimeout" ; ja:cxtValue "1000" ] ;
# Make the default graph be the union of all named graphs.
## tdb:unionDefaultGraph true ;
.
```

Once you've updated the path to your data, you can run Fuseki with (assuming you named the config file `assembler.ttl`):
```bash
./apache-jena-fuseki-2.3.1/fuseki-server --config=assembler.ttl
```
