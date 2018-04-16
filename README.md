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
```

### HTTP Standards

TODO

