class Curl::Easy
  protected def callback_compress!
    curl_easy_setopt(curl, CURLOPT_ACCEPT_ENCODING, "")
  end
end
