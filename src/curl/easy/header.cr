class Curl::Easy
  var headers : Hash(String, String) = Hash(String, String).new

  protected def callback_header!
    if v = user_agent?
      curl_easy_setopt(curl, CURLOPT_USERAGENT, v)
    end

    return if headers.empty?

    list = Pointer(LibCurl::CurlSlist).null
    headers.each do |k,v|
      list = LibCurl.curl_slist_append(list, "#{k}: #{v}")
    end
    curl_easy_setopt(curl, CURLOPT_HTTPHEADER, list)

    after_execute {
      LibCurl.curl_slist_free_all(list)
    }
  end
end
