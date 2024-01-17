# Contributor Onboarding
This document serves as a prerequisite knowledge checklist for Open Source contributors (Contributor(s)) to the Geoconnex system (System). The system is composed of multiple components which in turn leverage various Open Source software projects and their toolchains.  

# Assumptions

The Contributor should be become proficient with the following programming languagues, data models, file formats, toolchains, and last but not least, the Geoconnex Components and related dependent services that comprise the System.

## Programming Languages

* ### [Python](https://python.org)
* ### [Go](https://https://go.dev/)
* ### [Bash](https://www.gnu.org/software/bash/manual/bash.html)
* ### [SPARQL](https://www.w3.org/TR/sparql11-query/)

### Markup Languages

- HTML (.html)
- Markdown (.md)

## Data Models
* RDF
    - [RDF Primer](https://www.w3.org/TR/rdf11-primer/)
    - [RDF Concepts & Abstract Syntax](https://www.w3.org/TR/2014/REC-rdf11-concepts-20140225/)
    - [RDF Schema](https://www.w3.org/TR/2014/REC-rdf-schema-20140225/)
     - [RDF Semantics](https://www.w3.org/TR/2014/REC-rdf11-mt-20140225/)
    - [RDF Datasets](https://www.w3.org/TR/2014/NOTE-rdf11-datasets-20140225/)
    - [OWL2 Web Ontology Language](https://www.w3.org/TR/owl2-overview/)



## File Formats

* ### [Yaml](https://yaml.org/)
    - *See Also* [docker compose](#docker-compose)
* ### JSON
    - [JSON-LD](https://json-ld.org/)
* ### XML
* ### CSV
* ### [TOML](https://toml.io/en/)
* ### [Dockerfile](https://docs.docker.com/engine/reference/builder/) 
    - *See Also* [docker](#docker) 
* ### [Makefile](https://makefiletutorial.com/) 
    - *See Also* [make](#make)

## Tool(chain)s

* ### [docker](https://docs.docker.com/engine/reference/commandline/cli/) 
* ### [docker compose](https://docs.docker.com/compose/)
    - *See Also* [Yaml](#yaml), 
* ### [make](https://www.gnu.org/software/make/manual/make.html)
    - *See Also* [Makefile](#makefile)

## Software Frameworks

* ### Data Orchestration...
    - #### [Dagster](https://docs.dagster.io/getting-started?utm_source=google&utm_medium=cpc&utm_campaign=18132832715&utm_content=138233353817&utm_term=dag%20orchestration&gclid=CjwKCAiA75itBhA6EiwAkho9e3IGy6NQIF6hHnGOXWb7WUllguRcvHw7rT919J_DgTgcA8vpmkJnQBoCu9QQAvD_BwE)


## System Components 

### Geoconnex Components
* #### [Scheduler](https://github.com/gleanerio/scheduler)
    - *Depends On...* 
        - #### [Dagster](https://docs.dagster.io/getting-started?utm_source=google&utm_medium=cpc&utm_campaign=18132832715&utm_content=138233353817&utm_term=dag%20orchestration&gclid=CjwKCAiA75itBhA6EiwAkho9e3IGy6NQIF6hHnGOXWb7WUllguRcvHw7rT919J_DgTgcA8vpmkJnQBoCu9QQAvD_BwE)
        - #### [Gleaner](https://github.com/gleanerio/gleaner)
        - #### [Nabu](https://github.com/gleanerio/nabu) 

### Dependent (Cloud) Services 

See Also [Reference Services](README.md#reference-services)

* Object Storage
    - *Used By...*
        - [Geoconnex Components](#geoconnex-components) via S3 API
    - *Current Reference Implementation...*
        - [Minio](https://github.com/minio/minio)
    - *Potential Implementation Candidates...*
        - [Amazon S3](https://www.google.com/search?q=Amazon+S3)
        - [Google Cloud Storage](https://www.google.com/search?q=Google+Cloud+Storage)
        - [Azure Blob Storage](https://www.google.com/search?q=Azure+Blob+Storage)
* Graph Database (Triple Store)
    - *Used By ...*
        - [Scheduler](#scheduler) via [SPARQL 1.1](#sparql) API
    - *Current Reference Implementation...*
        - GraphDB
    - *Potential Implementation Candidates...*
        - Any SPARQL 1.1 API enabled triple store

