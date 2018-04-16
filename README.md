# Silly Cache

A caching reverse proxy that:

- is silly simple to use
- allows you to do silly things

## Usage

### Basic Usage

```
silly-cache --listen 6969 --backend www.the-site-i-want-to-proxy-and-cache.com
```

This starts a server listening on port 6969 that automatically caches the backend server following HTTP caching standards.


### Advanced Usage

```
silly-cache --listen 6969  \
            --backend www.the-site-i-want-to-proxy-and-cache.com \
            --rules $(cat rules.yaml)
```  

This starts a server listening on port 6969 that uses custom rules declared in a file `rules.yaml`.


Here's an example `rules.yaml` to show you the basics:

```yaml
global:
  http_standards: false
  ignore:
    paths:
      - /index.html
      - /admin/*

my_first_custom_rule:
  http_standards: true
  matches:
    - request_methods:
      - GET
    - header:
      - /requests-that-have-at-least-one-header-that-passes-this-regex-can-be-cached/

my_second_custom_rule:
  http_standards: false
  matches:
    - paths:
      - !/authentication/*
    - request_methods:
      - POST
    - body:
      - /foo/
      - !/bar/
  ttl: 4 hours
```

When given a collection of rules you can define how you want to cache certain request.

The global settings define general behaviour and then you can be really specific about certain requests by defining rules for them.

Rules define the caching behaviour but do not determine whether a request is proxied or not.

### HTTP Standards

TODO

