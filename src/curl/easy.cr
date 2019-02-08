class Curl::Easy < Curl::Base

  def get(path : String? = nil) : Response
    update_uri!(path)
    curl_easy_setopt!(CURLOPT_URL, uri.to_s)
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
