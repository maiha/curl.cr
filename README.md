# curl.cr

High level curl library for [Crystal](http://crystal-lang.org/).
This is a handy wrapper for blocknotes's [curl-crystal](https://github.com/blocknotes/curl-crystal)

- crystal: 0.27.0

## Installation

1. Add the dependency to your `shard.yml`:
```yaml
dependencies:
  curl:
    github: maiha/curl.cr
    version: 0.2.0
```
2. Run `shards install`

## Usage

```crystal
require "curl"

curl = Curl::Easy.new
res  = curl.get "http://examples.com"
res.body 
```

## Sample

`samples/crurl.cr` is an example using `libcurl` to make a `curl` compatible application in Crystal.

```console
$ make build
```

## Development

curl is a very multifunctional and large library, and the functionality implemented in this library is very small. If there is a missing function, please implement it. PR is greatly appreciated.

```console
$ make spec
```

### Constants

If you want to add new constants to [src/curl/const.cr](./src/curl/const.cr),
you must edit it's source file [gen/lib_curl_const.h](./gen/lib_curl_const.h).
And then, generate `src/curl/const.cr`.

```console
$ make src/curl/const.cr
```

### Docker

Rebuild docker containers after you modified [docker/*](./docker/).

```console
$ make rebuild-docker
```

## Static link

Minimum `libcurl.a` will be prepared as follows by `make libcurl.a`.

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
