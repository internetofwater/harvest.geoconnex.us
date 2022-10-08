# Documentation

## About

The documentation is broken down by the repository structure and also by
the roles (personas).  Additionally background
material is present on the various architecture and formats relevant to the work. 

## Document index
Additional documentation is located in the various sections of this repository 
and linked from here.

* [JSON-LD background](./jsonld.md)
* Server Setup [aggregator/configs/README.md](/aggregator/configs/README.md)
* Indexing Activities [aggregator/harvesting/README.md](/aggregator/harvesting/README.md)
* Reference interface [user/README.md](/user/README.md)
  
## Reference services

The following represent a set of reference implementation for the GeoConnex architecture.  

### Object Store

The reference architecture uses object stores as a fundamental component.  
The reference implementation uses the open source Minio package to provide this. 
However, any S3 compliant object store will work.  This means that Amazon AWS S3, 
Google Cloud Storage or any other such object store can be used. 

Gleaner has a _setup_ call that is used to init the object store for runs. 

#### Example

An implemenation of Minio exist for this stage of the work at:

https://oss.geoconnex.us

### Graph

As noted the approach uses the structure data on the web approach and aligns
with W3C standards and recommendations in this space.  This includes things like
JSON-LD, schema.org, Linked Data Platform and others.  

The result of this is that any graph database, triplestore, can be used.  For
this work, a reference implementation based on GraphDB is used since it provides
support of the GeoSPARQL standard.  If this spatial aspect was not need or addressed
in other methods any RDF based triple store could be used.

> Note:  Why property graph such as Neo4j for Janus are not directly supported, an
> RDF based graph can be converted for use in such graph systems.  If the property 
> graph approach exposed benefits needed by an implementor such an architecture is possible. 
> The effort involved is not large, but proper policy and proceedure changes might need
> to be implemented by a group wishing to leverage this approach. 

#### Example

An implemenation of GraphDB exist for this stage of the work at:

https://graph.geoconnex.us  

### Other Indexes

Since the approach is based heavily on managing digital objcects representing individual data
graphs, it is easy to modify the ELT style workflow.

As a bit of a digression at this point, the phrase ELT (Extract Load Translate) is used here over
the more common ETL (Extract Translate Load).   Mostly this is due to the fact that the JSON-LD
based objects can typically be loaded directly into many systms as obtained directly from the source.
Little effort is any is needed to feed them into other data indexes.

By exmaple, tools like MongoDB, ElasticSearch, Solr/Lucne, or cloud tools like AWS Athena, 
Google Big Query can work with JSON formats, often with little or no schema alterations on load.  

Notable exceptions to this would be the loading of the files into a spatial system other than 
a spatial enabled graph.  Here the process would need to extract the spatial elements as a stage
in the loading.  This could likely best be done via a JSON-LD frame on the key spatial elements.
For example, a geohash approach would involve the extraction of the spatial 
elements and then the use of them to generate the geohash entry along with a PID like 
reference, likely the data graph URI.   

#### Example

An implemenation of [https://www.meilisearch.com/](meilisearch) exist for this stage of the work at:

https://index.geoconnex.us  

This is a Rust based schema-less text indexing system that leverages JSON as an import format.  It is 
very easy to process JSON-LD documents directly into Meilisearch to explore text indexing approaches. 

### Reference interfaces

The architecture is desgined to support multiple approaches to interacting with the data.  
Examples of this include:

* one
* two

#### Example

An implemenation of a Javascript based UI exist for this stage of the work at:

https://search.geoconnex.us  

## Personas

This repository is divided up into these three related personas.  Some of the information 
for these personas is located in other GeoConnex repositories.  

![pub](./images/persona.png)

### Persona: Publisher

The Publisher is engaged authoring the JSON-LD documents and publishing them to the web. This persona is focused on describing and presenting structured data on the web to aid in the discovery and use the resources they manage.  
Additionally, this persona would be leveraging this encoding described in GeoConnex guidance. 

![pub](./images/persona.png)

### Persona: Aggregator

In the Aggregator is a person or organization who is indexing resources on the web using the structured data on the web patterns described in this documentation.
Their goal is to efficiently and efficiently index the resources exposed by the Publisher persona and generate usable indexes. Further, they would work to exposed these indexes in a manner that is usable by the User persona. 

![pub](./images/persona.png)

### Persona: User

The user is the individual or community who wished to leverage the indexes generated as a result of the publishing and aggregation activities. The user may be using the developed knowledge graph or some web interface built on top of the knowledge graph or other index. They may also use query languages like SPARQL or other APIs or even directly work with the underlying data warehouse of collected data graphs.
