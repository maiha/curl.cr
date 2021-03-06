# Add missing constants etc by hand.

module LibCurlCustom
  enum CURL_HTTP_VERSION
    CURL_HTTP_VERSION_NONE # setting this means we don't care
    CURL_HTTP_VERSION_1_0  # please use HTTP 1.0 in the request
    CURL_HTTP_VERSION_1_1  # please use HTTP 1.1 in the request
    CURL_HTTP_VERSION_2_0  # please use HTTP 2 in the request
    CURL_HTTP_VERSION_2TLS # use version 2 for HTTPS, version 1.1 for HTTP
    CURL_HTTP_VERSION_2_PRIOR_KNOWLEDGE # please use HTTP 2 without HTTP/1.1 Upgrade
    CURL_HTTP_VERSION_LAST # *ILLEGAL* http version
  end
end
