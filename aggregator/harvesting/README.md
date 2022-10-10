# Harvesting 

## About

Information on using the Docker based version of Gleaner to perform
aggregation runs.  


## Notes

First, make sure the main source bucket in your object store is set.  This is the 
bucket entry in the config file. 

```
bucket: iow_aggregation
```

You make need to make this with your object store tooling.  So for Minio this would
be mc and for AWS or Google it could be done at the web ui or whatever CLI tools you use.  

You will also need to set the accessKey and secretKey to your values.  Note, while the 
section is name "minio" these parameters work for AWS S3 or Google Cloud Storage approaches
as well.  

```
minio:
  address: SERVER_ADDRESS
  port: PORT
  accessKey: YOUR_ACCESS_KEY
  secretKey: YOUR_SECRET_KEY
  ssl: set true or false based on if SSL/https is used.
  bucket: YOUR_OBJECTSTORE_BUCKET_NAME   object prefixes used in Gleaner will append to this
```

Note that bucket names must follow S3 convention/limits on characters.  So underscores, upper case 
and some other characters can not be used.  See [AWS Bucket Name Rules](https://docs.aws.amazon.com/AmazonS3/latest/userguide/bucketnamingrules.html)) 
for guidance.   

You will need to run the script to have Gleaner setup it's initial template in the object store.
This will likely be removed soon as Gleaner will simply check for first run and do this on its own. 

```
./cliGleaner.sh  -a docker -cfg /wd/iow_config.yaml  -setup
```

Then run the script to index.  

```
./cliGleaner.sh  -a docker -cfg /wd/iow_config.yaml  -source damspids -rude
```

