# Future directions

## About

This document outlines some of the next steps based
on lessons learned and development in this and other related projects.

## Deployment

Though completely optional, the transition to using Portainer over
the base command line interface to the orchestration layer is suggested.

This is a web UI to the core Docker API.  As such, it doesn't not provide 
any new functionality nor does it replace the CLI.  Rather it can be used in 
parallel with the CLI and provide a friendly interface to some of the more 
tedious operations of Docker to do in the CLI.  Things such as volume and 
network management and related.

Extensive documentation on leveraging portainer in cloud or bare metal 
approaches is found at the Portainer documentation site.  

![portainer](./images/portainer.png)


## Workflows

A key next step is more the evolution of the the architecture.  It is 
the implementation of a workflow system to monitor the indexing and 
and validation of the sources.  This could be done with any of the exisintg
workflow system such as AirFlow, Prefect or others.    For this project
the workflow system Dagster was selected.

Work on this approach is taking place in the  GleanerIO schedular repository.
This approach has been used for other implementations of Gleaner and provides
a useful overview of operations and status.  

![dagstger](./images/dagster.png)

Currently implementd in this workflow are the harvesting and loading 
steps.

## Spatial Discrete Grids

The spatial nature of the harvested data provide a strong integration pattern 
for use with other groups.  In collaboration with other groups some work based
on the pattern Geoconnex selected is taking place to enable connections with 
source such as Google's Data Commons.  

The flow is basically a JSON-LD framing processes to extract spatial geometries
and then their convesion to the S2 discrete grid.  Based on that, grid cell IDs can
then be used to connect with the Data Commons.  

Similar work is taking place within the Know Where Graph work.  

## Cloud Native Formats

It is possible to store large amounts of RDF data generated in such projects 
in a manner that is both highly compressed and also rapidly accessible.
One possible implementation of this is based on work taking place in KGLabs 
for the storage of RDF in the Parquet format.

Beyond the compression of Parquet the ability to parse on both column and 
row groups provide some interesting approches to indexing and accessing 
large RDF data which can then be materialized into memory graphs for final 
query.   

Work within the NSF funded UFOKN (Urban Flooding Open Knowledge Network) is looking 
at the management of large scale RDF data collections.  This work is leveraing above 
mentioned Parquet based RDF indexing combined with an assest graph to manage how 
to query large RDF graphs without the need to materialize all the triples all the time. 


