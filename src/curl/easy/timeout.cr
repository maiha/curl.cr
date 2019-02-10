class Curl::Easy
  protected def callback_timeout!
    if v = connect_timeout?
      curl_easy_setopt(curl, CURLOPT_CONNECTTIMEOUT_MS, v.total_milliseconds)
    end

    if v = timeout?
      curl_easy_setopt(curl, CURLOPT_TIMEOUT_MS, v.total_milliseconds)
    end
  end
end
