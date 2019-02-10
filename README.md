# curl.cr

High level curl library for Crystal.
This is a handy wrapper for blocknotes's [curl-crystal](https://github.com/blocknotes/curl-crystal)

- crystal-0.27.0 : https://crystal-lang.org/
- curl-7_64_0 : https://github.com/curl/curl

## Installation

1. Add the dependency to your `shard.yml`:
```yaml
dependencies:
  curl:
    github: maiha/curl.cr
    version: 0.2.0
```
2. Run `shards install`

## Basic Usage

```crystal
require "curl"

curl = Curl::Easy.new("http://examples.com")
curl.get.body  # => "<html>..."
```

All available variables for `curl.xxx` are as bellows.

```crystal
  var logger = Logger.new(STDERR)
  var uri : URI
  
  var timeout         : Time::Span
  var connect_timeout : Time::Span

  var compressed = false # Request compressed response
  var verbose    = false # Set verbose mode
```

See [src/curl/base.cr](./src/curl/base.cr) for further details.

## Easy Interface

`libcurl` provides two interfaces those are `Easy` and `Multi`.
Easy Interface is standard api that provides **synchronous** access, and well used by many applications.

Implmented api: [doc/easy.md](./doc/easy.md)

## Multi Interface

Multi Interface provides **asynchronous** access.
(Not Implemented Yet)

## Roadmap

- Supported CURL Constants: [doc/const.md](./doc/const.md)

- Core
  - Auth
    - [x] #basic_auth
    - [ ] #digest_auth
  - Callback
    - [ ] before_execute
  - Compress
    - [x] #compressed=(v : Bool)
  - Logging
    - [x] #logger
  - Response
    - [ ] #headers
    - [x] #code
    - [x] #body
    - [x] #io
    - [x] #success?
  - Timeout
    - [x] connect_timeout
    - [x] timeout
  - URI
    - [x] #uri=(v)
    - [x] #port
  - Verbose
    - [x] #verbose
- Easy Interface : https://curl.haxx.se/libcurl/c/
  - [x] #get
  - [ ] #post
  - [ ] #put
- Multi Interface : https://curl.haxx.se/libcurl/c/libcurl-multi.html
  - [ ] #get
  - [ ] #post
  - [ ] #put

## Sample

[samples/crurl.cr](./samples/crurl.cr) is an example using `libcurl` to make a `curl` compatible application in Crystal.

```console
$ make build
```

## Development

curl is a very multifunctional and large library, and the functionality implemented in this library is very small. If there is a missing function, please implement it. PR is greatly appreciated.

```console
$ make spec
```

### Constants

[src/lib_curl_const.cr](./src/lib_curl_const.cr) is managed by [gen/const.cr](./gen/const.cr),
and generated from "curl/include/curl/curl.h" as follows.

```console
$ make const
```

### Document

- [doc/easy.md](./doc/easy.md) is generated as follows.

```console
$ make easy
```

### Docker

Rebuild docker containers if you modified [docker/*](./docker/).

```console
$ make rebuild-docker
```

## Static link

Minimum `libcurl.a` will be prepared as follows.

```console
$ make libcurl.a
...
[libcurl.a]
  curl version:     7.64.0-DEV
  Protocols:        HTTP HTTPS
   LIBS:            -lidn2 -lssl -lcrypto -lssl -lcrypto -lz
```

Then you can compile your apps by adding `--link-flags "-static $PWD/libcurl.a"`.

```console
$ crystal build app.cr --link-flags "-static $PWD/libcurl.a"
```

If your environment does not have a dependent library it will result in an error. In that case, you can easily create it by using the container that created `libcurl.a` as follows.

```console
$ docker-compose run --rm static crystal build app.cr --link-flags "-static /v/libcurl.a"
```

## Contributing

1. Fork it (<https://github.com/maiha/curl.cr/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [maiha](https://github.com/maiha) - creator and maintainer for this repository.
- [blocknotes](https://github.com/blocknotes) - author of `LibCurl` which is a function of lower layer
