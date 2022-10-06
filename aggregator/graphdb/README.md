# GraphDB

## About

This is a simple GraphDB instance for testing with a single instance of GraphDB.
A simple compose file is included with a Caddyfile.

## Caddy

For testing you can can alter the Caddyfile to something like

```
(cors) {
        @origin header Origin *
        header @origin Access-Control-Allow-Origin *
        header @origin Access-Control-Request-Method *
        header @origin Access-Control-Request-Headers *
}

dev.graph.geoconnex.us {
   reverse_proxy graphdb:7200
}

```

Replace _dev.graph.geconnex.us_ with a local dev domain such  
as _graph.lan_ or whatever you wish.

