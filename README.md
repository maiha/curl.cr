# curl.cr

High level curl library for Crystal.
This is a handy wrapper for blocknotes's [curl-crystal](https://github.com/blocknotes/curl-crystal)

- crystal-0.27.0 : https://crystal-lang.org/
- curl-7_64_0 : https://github.com/curl/curl
  - `Multi` interface requires 7.28.0 or above.

## Installation

1. Add the dependency to your `shard.yml`:
```yaml
dependencies:
  curl:
    github: maiha/curl.cr
    version: 0.3.1
```
2. Run `shards install`

## Usage

`libcurl` provides two interfaces those are `Easy` and `Multi`.
Easy Interface is standard api that provides **synchronous** access, and well used by many applications.

## Easy Interface

`Curl::Easy#get` returns `Curl::Easy::Response`.

```crystal
require "curl"

curl = Curl::Easy.new("http://examples.com")
res = curl.get
res.code         # => 200
res.content_type # => "text/html; charset=UTF-8"
res.body         # => "<html>..."

curl.to_s        # => "200 http://examples.com"
```

See [src/curl/easy.cr](./src/curl/easy.cr) for all variables.

```crystal
  var uri      : URI
  var logger   : Logger
  var response : Response
  var info     : Info

  # behavior
  var dump_header = false # Pass headers to the data stream
  var verbose     = false # Set verbose mode
  
  var timeout         : Time::Span
  var connect_timeout : Time::Span

  var compress : Bool     = false
  var encoding : Encoding = Encoding::ALL
  var decoding : Bool     = true
```

- See [doc/easy.md](./doc/easy.md) for implemented `Easy` functions.

### Curl::Easy::Info

`Curl::Easy::Response#info` returns `Curl::Easy::Info`.

```crystal
info = curl.get.info
info.namelookup_time # => 0.00439
info.to_s            # => "[10.0KB](232KB/s, 0.0s)"
puts res.info.times_overview
```

```
(0.004s) |--NAMELOOKUP
(0.018s) |--|--CONNECT
(0.000s) |--|--|--APPCONNECT
(0.018s) |--|--|--|--PRETRANSFER
(0.032s) |--|--|--|--|--STARTTRANSFER
(0.032s) |--|--|--|--|--|--TOTAL
(0.000s) |--|--|--|--|--|--REDIRECT
```

- See [src/curl/easy/info.cr](./src/curl/easy.cr) for all variables.

### Compress

Compression is enabled by default, but you can use three variables to control fine behavior. For example, it is possible to acquire route compressed `gzip` data as it is by requesting encoding by gzip compression and skipping decoding, as follows.

```crystal
curl.compress = true
curl.encoding = Curl::Easy::Encoding::GZIP
curl.decoding = false
```

## Multi Interface

Execution of requests by `Easy` is blocked at the libcurl level, so even if executed within `spawn`, execution of crystal is blocked there. 

Multi Interface provides **asynchronous** access. It enables multiple simultaneous transfers in the same thread without making forks.

```crystal
multi = Curl::Multi.new
multi << Curl::Easy.new("https://example.com")
multi << Curl::Easy.new("https://github.com")
multi.run(timeout: 10.seconds)

multi.map(&.code)       # => [200, 200]
multi.human_code_counts # => {"200" => 2}
```

- See [doc/multi.md](./doc/multi.md) for implemented `Multi` functions.

## Roadmap

- Core
  - Auth
    - [x] #basic_auth
    - [ ] #digest_auth
  - Callback
    - [ ] before_execute
  - Compress
    - [x] #compress=(v : Bool)           # control 'Accept-Encoding' header
    - [x] #encoding=(v : Easy::Encoding) # specify the value of encoding
    - [x] #decoding=(v : Bool)           # control automatic decompression
  - Info
    - [x] times stats
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
  - [x] #<<(easy : Easy)
  - [x] #run(timeout)
  - [x] #requests : Array(Easy)
  - [x] #responses : Array(Multi::Response)

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

All constants in `libcurl` are mapped to `Curl::XXX`.
For example, `CURLOPT_VERBOSE` is declared as `enum`. So it can be used as follows.

```crystal
Curl::CURLOPT_VERBOSE.value # => 41
```

See [doc/const.md](./doc/const.md) for further details.

### Symbols

All symbols are extracted to `LibCurlSymbols` from <https://github.com/curl/curl/blob/master/docs/libcurl/symbols-in-versions>.

```crystal
LibCurlSymbols.each do |symbol|
  symbol # => LibCurlSymbols::CurlSymbol(@name="CURLAUTH_ANY", @introduced="7.10.6", @deprecated="", @removed="")
```

### Automatically generated files

- [src/lib_curl_const.cr](./src/lib_curl_const.cr)
- [src/lib_curl_symbols.cr](./src/lib_curl_symbols.cr)
- [doc/const.md](./doc/const.md) 
- [doc/easy.md](./doc/easy.md) 

```console
$ make gen
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
