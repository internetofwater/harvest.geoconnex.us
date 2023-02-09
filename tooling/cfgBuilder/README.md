# Tooling

## About

Supporting tooling.

## cfgBuilder

Reads a sitemap index and generates a config file for Gleaner
with each sitemap in the index a source entry.

A basic attempt is made to parse the URL into a logic name with
an index number appended to ensure uniqueness.  This is a rather
brittle approach though given the potential changes in the sitemap
URL.  So, you may need to alter those elements of the code to
address your particular needs.

## Usage

```
python cfgBuilder.py -s https://geoconnex.us/sitemap.xml
```

Thsi will generate the file ```gleanerconfig.yaml``` That is used both by Gleaner but
also by the code generator script in the dagster section of this repository.

