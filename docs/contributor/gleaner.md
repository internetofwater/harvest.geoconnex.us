# Gleaner Quickstart

This document serves to familiarize the *Contributor* with Gleaner by showing how to build and run it from source in a local build environment (*Environment*).


# Prerequisites

In order to build Gleaner you must have the following installed in your *Environment*. 

Note that these commands have only been tested under the amd64 (Intel) architecture machines. 

## Go(lang)

Go can be downloaded through various o/s distribution package managers or downloaded and installed directly from the main [Go download site](https://go.dev/dl/). 

As of this writing, Gleaner required version 1.19 or greater. See the Gleaner [go.mod file](https://github.com/gleanerio/gleaner/blob/master/go.mod) and look for line `go <version>` for the authoritative minimum required version.

This document may reference the `GOPATH`  environment variable which points to the base directory where go modules/programs are located and produced. If you do not have it set, it will default to the  `go/` subdirectory of your user home directory (i.e.   `$HOME/go` in Unix-like systems). 

Please see [Go developer documentation](https://go.dev/doc/) for more details. 


## Make

Gleaner uses `make` utility to build the `gleaner` binary. Please ensure it is part of your Environment. 

## Docker
Docker is used here to launch Gleaner developer runtime service dependencies S3(Minio) and a SPARQL(GraphDB). 

## mc (Minio client)

`mc` is the command line Minio client utility. It is used to verify Gleaner runtime outputs. 

You can find information on how to install `mc` [here](https://min.io/docs/minio/linux/reference/minio-mc.html#quickstart). 

Run the following to add an alias to your minio server (minio) with the admin user/password set to `amazingaccesskey/amazingsecretkey`. 

```
mc alias set myminio http://localhost:9000 amazingaccesskey amazingsecretkey
```




# Building Gleaner

## Fork
Fork [Gleaner on github.com](https://github.com/gleanerio/gleaner) to your github.com organization/user account (<GH_USER>).

## Clone
Clone Gleaner from your forked github repository to your *Environment* in a predefined directory location (<SRC_BASE_DIR>).

```
cd <SRC_BASE_DIR>
git clone git@github.com:<GH_USER>/gleaner.git
```


## Build

### Build Gleaner Binary
To build the Gleaner binary, perform the following...

```
cd <SRC_BASE_DIR>/gleaner
make gleaner
```

### Dockerize Gleaner Binary

```
cd <SRC_BASE_DIR>/gleaner
docker build -f build/Dockerfile -t "gleanerio/gleaner:$(cat VERSION)" .
```

# Running Gleaner 

## Runtime Dependencies

### Minio
Gleaner requires a configured [S3 compliant service](../README.md#object-store) to run. For development purposes, a single node Minio Object Server will suffice. 

To run Minio as a container without storage persisting upon container exit run...

```
docker run -d \
   -p 9000:9000 \
   -p 9001:9001 \
   --name minio \
   -e "MINIO_ROOT_USER=amazingaccesskey" \
   -e "MINIO_ROOT_PASSWORD=amazingsecretkey" \
   quay.io/minio/minio server /data --console-address ":9001"
```

To run Minio as a container **WITH** storage persisting upon container exit, run...

```
mkdir -p ~/minio/data

docker run -d \
   -p 9000:9000 \
   -p 9001:9001 \
   --name minio \
   -v ~/minio/data:/data \
   -e "MINIO_ROOT_USER=amazingaccesskey" \
   -e "MINIO_ROOT_PASSWORD=amazingsecretkey" \
   quay.io/minio/minio server /data --console-address ":9001"
```

#### Verify & Prepare Minio Runtime For Gleaner

Run `docker ps` to verify minio is running. 

Create an S3 bucket named 'mybucket' in Minio by running...

```
mc mb myminio/mybucket
```

This bucket name(mybucket) is referenced in [your sample Gleaner config](sample.gleanerconfig.yaml)  `minio:` > `bucket:` nested YAML property value.

### Headless Chrome
Some Gleaner sources render their JSON-LD documents in JavaScript in the browser runtime. To address this, Gleaner uses the 'headless' Chrome browser service to render the JSON for a given source and return it to Gleaner.  To use the service, run the following command...

```
docker run -d chromedp/headless-shell -p 9222:9222
```

## Configuring Gleaner

1. Create a directory to hold Gleaner runtime files (<RUNTIME_DIR>).
2. Change directories `cd <RUNTIME_DIR>`
3. Download Schema.org's JSON-LD ontology...
    1. `curl https://schema.org/version/latest/schemaorg-current-https.jsonld -o schemaorg-current-https.jsonld`
    2. `curl https://schema.org/version/latest/schemaorg-current-https.jsonld -o schemaorg-current-http.jsonld`
4. Create file `<RUNTIME_DIR>/gleanerconfig.yaml` and copy/paste [this content](sample.gleanerconfig.yaml) into the file and save. 

## Running Gleaner

To run Gleaner using the runtime dependencies and files created in the previous step, do the following...

```
cd <RUNTIME_DIR>
<SRC_BASE_DIR>/gleaner --cfg ./gleanerconfig.yaml --rude  
```

You can also run Gleaner to target a specific source defined in `gleanerconfig.yaml` by specifing `--source` as follows:

```
cd <RUNTIME_DIR>
<SRC_BASE_DIR>/gleaner --cfg ./gleanerconfig.yaml --source counties0 --rude  
```

...where `counties0` is referenced in [gleanerconfig.yaml](sample.gleanerconfig.yaml) in the YAML nested property `sources:` > `properName:`.

## Verifying Gleaner S3 Output

To verify Gleaner is harvesting JSON-LD documents from configured source(s) run the following...
```
mc ls myminio/mybucket/orgs
```

The above command should list *.nq file(s).

Now run...
```
mc ls myminio/mybucket/prov/counties0
mc ls myminio/mybucket/summoned/counties0
```

The above commands should list *.jsonld files.


### Harvesting From Multiple Sources
You can add additional sources to your Gleaner configuration `sources:` section by adding any  URL entries found within the `<loc></loc>` of the Geoconnex [sitemap.xml](https://geoconnex.us/sitemap.xml) XML document by configuring them within the `sources:` section of your gleaner configuration file. 











