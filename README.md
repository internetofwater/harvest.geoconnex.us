![pub](docs/images/logo.png)

# harvest geoconnex.us

### Running notes
https://docs.google.com/document/d/1IyCmuVbwv8oiyAf9zas2uZVl_sQ7pCQugcQjdIXVksk/edit

## About


This repository holds information on the publishing, aggregation and use of data associated with the geoconnex knowledge graph.  Documentation on this approach and links to the various README and external reference can be accessed from the main [README.md in docs](./docs/README.md).  

## Personas

![pub](docs/images/persona.png)

This repository is divided up into these three related personas.  Some of the information for these personas is located in other GeoConnex repositories.  

### Persona: Publisher


The Publisher is engaged authoring the JSON-LD documents and publishing them to the web. This persona is focused on describing and presenting structured data on the web to aid in the discovery and use the resources they manage. Additionally, this persona would be leveraging this encoding described in GeoConnex guidance. 

### Persona: Aggregator

In the Aggregator is a person or organization who is indexing resources on the web using the structured data on the web patterns described in this documentation.  Their goal is to efficiently and efficiently index the resources exposed by the Publisher persona and generate usable indexes. Further, they would work to exposed these indexes in a manner that is usable by the User persona. 

### Persona: User

The user is the individual or community who wished to leverage the indexes generated as a result of the publishing and aggregation activities. The user may be using the developed knowledge graph or some web interface built on top of the knowledge graph or other index. They may also use query languages like SPARQL or other APIs or even directly work with the underlying data warehouse of collected data graphs.


## Developer Onboarding



