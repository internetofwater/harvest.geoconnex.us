# Workflows

## About

This section holds information on workflow or scheduling approaches.  There are many
approaches to this in the community.  These include tools like simple cron scripts
all the way to systems like [Apache Airflow](https://airflow.apache.org/) or [Prefect](https://www.prefect.io/).

For this section, the reference implementation will use [Dagster](https://dagster.io/).  
However, any of these approaches or others could also address this functional need.  

As this section evolves it will hold documentation for the deployment of Dagster in a Docker
orchestration environment via Docker Compose files. 


## Notes

Initial compose file structure is below.  However, it relies on a custom Docker image
holding the Dagster repository.  The Dagster repository is made up of python code defining
the jobs an job schedules for the workflow.  


DRAFT compose file:


```
services:
  dagster-dagit:
    image: docker.io/fils/dagster:0.0.23
    environment:
    - PROTOCOL_BUFFERS_PYTHON_IMPLEMENTATION=python
    ports:
      - 3000:3000
  dagster-daemon:
    image: docker.io/fils/dagster:0.0.23
    environment:
    - PROTOCOL_BUFFERS_PYTHON_IMPLEMENTATION=python
    command: "dagster-daemon run"
  dagster-postgres:
    image: postgres:13.3
    ports:
      - 5432:5432
    environment:
      - POSTGRES_PASSWORD=secret
    volumes:
      - dagster-postgres:/var/lib/postgresql/data
volumes:
  dagster-postgres:
    driver: local
    ```