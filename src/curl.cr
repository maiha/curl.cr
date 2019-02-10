# stdlib
require "uri"
require "logger"

# shards
require "var"
require "curl-crystal"

# @[Link(ldflags: "`command -v curl-config > /dev/null && curl-config --static-libs || printf %s '-lcurl'`")]

@[Link(ldflags: "-lidn2 -lssl -lcrypto -lz")]
lib LibCurl
end

require "./lib_curl_const"
module Curl
  # Shortcuts for `LibCurl`
  alias Lib    = LibCurl
  alias Code   = Lib::CURLcode

  # flatten enum into const
  {% for member in LibCurl::CURLoption.constants %}
    {{member}} = LibCurl::CURLoption::{{member}}
  {% end %}

  include LibCurlConst
end

require "./curl/*"
