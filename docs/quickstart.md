# Quick Start

## About 

This document provides a quick overview for the set up of a hosting 
environment and some initial simple indexing on a few providers.  

Though not a guide for a more production level implementation, it 
is very close in many regards. The main difference really being
that scaling and structure of the orchestration environment.   Here,
the environment is single host machine.  

## Quick Start Support Architecture

```bash
git clone https://github.com/internetofwater/harvest.geoconnex.us
```

```bash
cd aggregator/configs/
```

```bash
docker-compose -f iowcompose_volumes.yml up
```

Can use volumes or mounted file system.  Leverage the setenv.sh script
if doing the later


## Quick Start Indexing example

From the root of the repository


```bash
cd aggregator/harvesting/
```

```
./cliGleaner.sh  -a docker -cfg /wd/iow_local.yaml  --source damspids -rude
```

### Config file overview


```yaml
---
minio:
  address: 192.168.202.114
  port: 49155
  accessKey:
  secretKey:
  ssl: false
  bucket: iow
gleaner:
  runid: iow # this will be the bucket the output is placed in...
  summon: true # do we want to visit the web sites and pull down the files
  mill: false
context:
  cache: true
contextmaps:
- prefix: "https://schema.org/"
  file: "./jsonldcontext.json"  # wget http://schema.org/docs/jsonldcontext.jsonld
- prefix: "http://schema.org/"
  file: "./jsonldcontext.json"  # wget http://schema.org/docs/jsonldcontext.jsonld
summoner:
  after: ""      # "21 May 20 10:00 UTC"   
  mode: full  # full || diff:  If diff compare what we have currently in gleaner to sitemap, get only new, delete missing
  threads: 5
  delay:  # milliseconds (1000 = 1 second) to delay between calls (will FORCE threads to 1) 
  headless: http://0.0.0.0:9222  # URL for headless see docs/headless
millers:
  graph: true
sources:
...
```


## Quick Start object loading

The final exmaple step is the loading of the harvested resources into an index.  The 
primary index is a triplestore such as Jena or GraphDB.  The following commands along
with the associated config file can be used to load resources into a designated triplestore.  

```
 ./nabuDocker.sh  --cfg /nabu/wd/iow_nabu.yaml  prefix -s summoned/gages21
```

which is a scripting wrapping the Docker command similar to 

```
podman run --privileged --network=host --interactive --tty --rm --volume "$PWD":/nabu/wd --workdir /nabu/wd "localhost/fils/nabu:2.0.1-developement" --cfg /nab
u/wd/iow_nabu.yaml  prefix -s summoned/gages21
```


