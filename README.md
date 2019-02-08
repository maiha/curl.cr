# curl.cr

curl for [Crystal](http://crystal-lang.org/).

- crystal: 0.27.0

## Installation

1. Add the dependency to your `shard.yml`:
```yaml
dependencies:
  curl:
    github: maiha/curl.cr
    version: 0.1.0
```
2. Run `shards install`

## Usage

```crystal
require "curl"
```

TODO: Write usage instructions here

## Static link

You need to install dependent libraries as follows.
```console
$ pkg-config --libs libcurl --static
 -L/usr/lib/x86_64-linux-gnu/mit-krb5 -lcurl -lidn -lrtmp -lssl -lcrypto -lssl -lcrypto -Wl,-Bsymbolic-functions -Wl,-z,relro -lgssapi_krb5 -lkrb5 -lk5crypto -lcom_err -llber -lldap -lz
``` 

And then, pass `-Dstatic` flag to crystal compiler in build command.
It is easiest to use docker.
```console
$ docker-compose run --rm builder crystal build -o bin/curl samples/curl.cr --link-flags 
```

## Development

TODO: Write development instructions here

## Contributing

1. Fork it (<https://github.com/maiha/curl.cr/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [maiha](https://github.com/maiha) - creator and maintainer
