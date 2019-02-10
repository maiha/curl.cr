# stdlib
require "uri"
require "logger"

# shards
require "curl-crystal"
require "var"
require "pretty"

# @[Link(ldflags: "`command -v curl-config > /dev/null && curl-config --static-libs || printf %s '-lcurl'`")]

@[Link(ldflags: "-lidn2 -lssl -lcrypto -lz")]
lib LibCurl
end

require "./lib_curl_const"
require "./lib_curl_custom"
require "./lib_curl_symbols"

module Curl
  # Shortcuts for `LibCurl`
  alias Lib    = LibCurl
  alias Code   = Lib::CURLcode

  # flatten enum into const
  {% for member in LibCurl::CURLoption.constants %}
    {{member}} = LibCurl::CURLoption::{{member}}
  {% end %}
  {% for member in LibCurl::CURLINFO.constants %}
    {{member}} = LibCurl::CURLINFO::{{member}}
  {% end %}
  {% for member in LibCurlCustom::CURL_HTTP_VERSION.constants %}
    {{member}} = LibCurlCustom::CURL_HTTP_VERSION::{{member}}
  {% end %}

  include LibCurlConst

  # Global initialization. Call here for multi thread.
  Lib.curl_global_init(CURL_GLOBAL_ALL)
end

require "./curl/*"
