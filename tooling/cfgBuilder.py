import json
import yaml

sources = []

# Using readlines()
file1 = open('xmlloc.txt', 'r')
Lines = file1.readlines()


# >>> from urllib.parse import urlparse
# >>> urlparse("scheme://netloc/path;parameters?query#fragment")
# ParseResult(scheme='scheme', netloc='netloc', path='/path;parameters', params='',
                        # query='query', fragment='fragment')
# >>> o = urlparse("http://docs.python.org:80/3/library/urllib.parse.html?"
                 # ...              "highlight=params#url-parsing")

count = 0
# Strips the newline character
for line in Lines:
    data = {}
    count += 1
    # print("Line{}: {}".format(count, line.strip()))
    keystr = str("Line{}".format(count))
    data["sourcetype"] = "sitemap"
    data["name"] = str("name{}".format(count))
    data["url"] = line.strip()
    data["headless"] = "false"
    data["pid"] = "https://gleaner.io/genid/geoconnex"
    data["propername"] = str("name{}".format(count))
    data["domain"] = "https://geoconnex.us"
    data["active"] = "true"
    sources.append(data)

json_data = json.dumps(sources)
print(json_data)

with open('data.yml', 'w') as outfile:
        yaml.dump(sources, outfile, default_flow_style=False)

