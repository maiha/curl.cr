class Curl::Easy < Curl::Base
  # Automatically create instances with initial access
  var curl : Lib::CURL* = Lib.curl_easy_init

  def get(path : String? = nil) : Response
    update_uri!(path)
    curl_easy_setopt(curl, CURLOPT_URL, uri.to_s)
    return execute
  ensure
    cleanup
  end
  
  protected def cleanup
    if _curl = curl?
      Lib.curl_easy_cleanup(_curl)
    end
  end

end
