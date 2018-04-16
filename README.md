# Silly Cache

A caching reverse proxy that allows you to do silly things, like not follow HTTP caching standards.

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
      - /requests-that-have-at-least-one-header-that-matches-this-regex-will-be-cached/

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

When http standard caching is enable (which it is be default) caching will follow the standards outlined here: https://tools.ietf.org/html/rfc7234

## TODO

- [ ] Get a basic proxy working without cache with no configuration (everything hardcoded).
- [ ] Allow the listening port to be configured.
- [ ] Allow the backend server to be configured.
- [ ] Enable HTTP standard caching.
- [ ] Make HTTP standard caching the default but able to be disabled.
- [ ] Allow rules to be set via yaml. Initially just global rules that override/replace command line args.
- [ ] Allow custom rules to configure paths.
- [ ] Allow custom rules to configure request methods.
- [ ] Allow custom rules to configure header matching.
- [ ] Allow custom rules to configure body matching.
- [ ] Allow custom rules to configure NOT matching (path, header, body). 
- [ ] Allow custom rules to configure cache TTLs. 
