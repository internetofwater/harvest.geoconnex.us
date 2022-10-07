# User 

## About

This section contains code and resources for the end user of the system.  This would include notebooks, query examples and other material.

## Notebooks

The web architecture approach for the GeoConnex metadata means that a wide range of existing tooling is available to use out of box.  Leveraging this some basic Jupyter notebooks are being developed with the intention that they provide a reference for others to build more focused and mission or policy drive tools from.  

This work in progress includes:

* [query example to the graph](./notebooks/IoWSPARQL.ipynb)
* [data overview examples](./notebooks/IoWreport.ipynb)

## Web

The web interface is build completely in HTML and Javascript. 
It communicates with the server side completely over APIs and 
other HTTP based calls.  

As such there are no direct dependancies between the two parts 
and the interface can be replaced or suplimented with other tooling.

For example,, more vertical interfaces into the graph and object store could take place easily based on open source packages such as [Streamlit](https://streamlit.io/) or [Dash](https://dash.plotly.com/).  These approaches would leverage work done in the noetbook section as well.  



