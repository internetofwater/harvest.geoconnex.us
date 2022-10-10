import json
import yaml
from urllib.parse import urlparse

# https://docs.aws.amazon.com/AmazonS3/latest/userguide/bucketnamingrules.html

# Using readlines()
f = open('xmlloc.txt', 'r')
Lines = f.readlines()

sources = []
count = 0
# Strips the newline character
for line in Lines:
    data = {}
    count += 1
    # set up a name based on the URL structure (DANGER:  this code is fragile)
    o = urlparse(line)
    ps = o.path
    x = ps.split("/")
    name = x[2].lower().replace("-", "")
    # print("Line{}: {}".format(count, line.strip()))
    # keystr = str("Line{}".format(count))
    data["sourcetype"] = "sitemap"
    data["name"] = str("{}{}".format(name, count))
    data["url"] = line.strip()
    data["headless"] = "false"
    data["pid"] = "https://gleaner.io/genid/geoconnex"
    data["propername"] = str("{}{}".format(name, count))
    data["domain"] = "https://geoconnex.us"
    data["active"] = "true"
    sources.append(data)

# json_data = json.dumps(sources)
# print(json_data)

with open('sources.yml', 'w') as outfile:
        yaml.dump(sources, outfile, default_flow_style=False)

