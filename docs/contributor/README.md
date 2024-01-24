# Contributor Onboarding
This document serves as a prerequisite knowledge checklist for Open Source contributors (Contributor(s)) to the Geoconnex system (System). The System is composed of multiple components which in turn leverage various Open Source software projects and their toolchains.  

# Prerequisite Knowledge

The Contributor should be become proficient with the following programming languagues, data models, file formats, toolchains, and last but not least, the Geoconnex Components and related dependent services that comprise the System.

## Programming Languages

### [Python](https://python.org)
What the [Scheduler](#scheduler) Geoconnex component is written in. 
### [Go](https://https://go.dev/)
What the [Gleaner](#gleaner) and [Nabu](#nabu) Geoconnex components are written in.
### [Bash](https://www.gnu.org/software/bash/manual/bash.html)
Used to create various scripts in the [Geoconnex component](#geoconnex-components) toolchain
### [SPARQL](https://www.w3.org/TR/sparql11-query/)
Used to interact with the [Graph Database](#graph-database).

### Markup Languages

#### Markdown (.md)
Used to create documentation for all identified [Personas](README.md#personas)

## Data Models

## RDF/JSON-LD
A working knowledge of RDF concepts, especially in the JSON-LD serialization format, is essential to understanding the System. The System's common vocabulary defined in RDF/JSON-LD is essential to the interactions between [Publishers](README.md#persona-publisher) model their data for consumption by [Aggegrators](README.md#persona-aggregator) and advanced [Users](README.md#persona-user) that leverage the System's [Graph Database](#graph-database) directly. 


* [RDF Primer](https://www.w3.org/TR/rdf11-primer/)
* [RDF Concepts & Abstract Syntax](https://www.w3.org/TR/2014/REC-rdf11-concepts-20140225/)
* [RDF Schema](https://www.w3.org/TR/2014/REC-rdf-schema-20140225/)
* [RDF Semantics](https://www.w3.org/TR/2014/REC-rdf11-mt-20140225/)
* [RDF Datasets](https://www.w3.org/TR/2014/NOTE-rdf11-datasets-20140225/)
* [OWL2 Web Ontology Language](https://www.w3.org/TR/owl2-overview/)
* [JSON-LD](https://json-ld.org/)

RDF/JSON-LD knowledge is essential to understanding how [Publishers](README.md#persona-publisher) model their data for consumption by [Aggegrators](README.md#persona-aggregator) and advanced [Users](README.md#persona-user) that leverage the System's [Graph Database](#graph-database) directly. 


## File Formats

### YAML 
Configuration file format used across [Geoconnex components](#geoconnex-components) and their dependencies.
### JSON
File format used to structure JSON-LD documents made available and harvested from  [Publisher](README.md#persona-publisher) web pages. See also [JSON-LD](#json-ld)
### CSV

### [TOML](https://toml.io/en/)
Configuration file used in  Dagster (i.e. Scheduler)) project configuration. See `pyproject.toml` references in Dagster documentation.    
### [Dockerfile](https://docs.docker.com/engine/reference/builder/) 
File format used to build Docker images. Specifies how to package all [Geoconnex components](#geoconnex-components). 

### [Makefile](https://makefiletutorial.com/) 
A file format which defines a task or set of tasks (i.e. shell commmands) to be executed that are typically declared in a dependency chain.  [Gleaner](#gleaner), [Nabu](#nabu) use Makefiles to build their software binaries.  [Scheduler](#scheduler) use it to declare various environment specific build lifecycle tasks.

## Tool(chain)s

[Geoconnex components](#geoconnex-components) are invariably deployed and orchestrated as Docker containers at runtime. 

### [docker](https://docs.docker.com/engine/reference/commandline/cli/) 
### [docker compose](https://docs.docker.com/compose/)
*See Also* [Yaml](#yaml), 
### [make](https://www.gnu.org/software/make/manual/make.html) 
*See Also* [Makefile](#makefile)

## Software Frameworks

[Dagster](https://docs.dagster.io/getting-started?) is a data orchestration framework from which [Scheduler](#scheduler) is built upon and deployed by [Aggregators](README.md#persona-aggregator). The data pipeline created by the System which connects [Publishers](README.md#persona-publisher) to [Users](README.md#persona-user) is  performed here. 


## System Components 

### Geoconnex Components

#### [Scheduler](https://github.com/gleanerio/scheduler) 

Scheduler is used by [Aggregators](README.md#persona-aggregator) to harvest (JSON-LD) data from [Publishers](../README.md#persona-publisher) to its final form as a [Knowledge Graph](README.md#graph) for use by [Users](README.md#persona-user). It is implemented  using the [Dagster](#dagster) orchestration framework and deployed via Dagster's runtime components. 

Some key Dagster concepts employed by Scheduler are...

- Assets
- Asset Groups
- Jobs
- Schedules
- Runs
- Deployments

Relevant Dagster runtime components used by Scheduler are as follows:

- `dagster-webserver`
- `dagster-daemon`
- `dagster api grpc`

Other Geoconnex components orchestrated by Scheduler via Dagster are Gleaner and Nabu. 

#### [Gleaner](https://github.com/gleanerio/gleaner)
Gleaner Extracts JSON-LD from web pages. To create a local Gleaner development environment, please visit [Gleaner Quickstart](gleaner.md).
#### [Nabu](https://github.com/gleanerio/nabu) 
Nabu loads data graphs into triple-stores. To create a local Nabu development environment, please visit [Nabu Quickstart](nabu.md).


### Dependent (Cloud) Services 

See Also [Reference Services](README.md#reference-services)

#### Object Storage

Used by [Geoconnex Components](#geoconnex-components) via S3 API interactions as a staging store while processing harvested data from [Publishers](README.md#persona-publisher). The current reference implementation used by harvest.geoconnex.us is [Minio](https://github.com/minio/minio) although any S3 API compliant object store such as [Amazon S3](https://www.google.com/search?q=Amazon+S3), [Google Cloud Storage](https://www.google.com/search?q=Google+Cloud+Storage), or [Azure Blob Storage](https://www.google.com/search?q=Azure+Blob+Storage) could be used as well by [Aggegators](README.md#persona-aggregator).

#### Graph Database

Used by [Nabu](#nabu), [Scheduler](#scheduler) via [SPARQL 1.1](#sparql) API interactions to load [Publisher](README.md#persona-publisher) source data represented as RDF triples. The current reference inpmlementation graph database used by graph.geoconnex.us is GraphDB.  However any SPARQL 1.1 enabled graph database could be used by [Aggregators](README.md#persona-aggregator).

