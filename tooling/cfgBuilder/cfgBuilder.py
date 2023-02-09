import json
import yaml
from urllib.parse import urlparse
from bs4 import BeautifulSoup
import requests
import argparse

# Notes
# https://docs.aws.amazon.com/AmazonS3/latest/userguide/bucketnamingrules.html

# Initialize args  parser
parser = argparse.ArgumentParser()
parser.add_argument("-s", "--SiteIndex", help = "URL to sitemap index")
args = parser.parse_args()

# Deprecated: Using readlines() on a file
# f = open('xmlloc.txt', 'r')
# Lines = f.readlines()

# parse the sitemap INDEX for the referenced sitemaps for a config file
Lines = []
xmlDict = {}

r = requests.get(args.SiteIndex)
xml = r.text
soup = BeautifulSoup(xml, features='xml')
sitemapTags = soup.find_all("sitemap")

for sitemap in sitemapTags:
    # print(sitemap.findNext("loc").text)
    Lines.append(sitemap.findNext("loc").text)


sources = []
count = 0
# Strips the newline character
for line in Lines:
    data = {}
    count += 1
    # set up a name based on the URL structure (DANGER:  this code is fragile)
    # o = urlparse(line)
    # ps = o.path
    # x = ps.split("/")
    # name = x[2].lower().replace("-", "")
    # print("Line{}: {}".format(count, line.strip()))
    # keystr = str("Line{}".format(count))

    target = line.rsplit('/', 1)[-1]

    name = target.lower().replace(".xml", "").replace("_", "")

    data["sourcetype"] = "sitemap"

    # data["name"] = str("{}{}".format(name, count))
    data["name"] = str("{}".format(name))

    data["url"] = line.strip()
    data["headless"] = "false"
    data["pid"] = "https://gleaner.io/genid/geoconnex"

    # data["propername"] = str("{}{}".format(name, count))
    data["propername"] = str("{}".format(name))

    data["domain"] = "https://geoconnex.us"
    data["active"] = "true"
    sources.append(data)

# json_data = json.dumps(sources)
# print(json_data)

# read the PREFIX file# Reading data from file1
with open('gleanerconfigPREFIX.yaml') as fp:
    data = fp.read()

with open('gleanerconfig.yaml', 'w') as outfile:
    outfile.write(data)
    yaml.dump(sources, outfile, default_flow_style=False)
