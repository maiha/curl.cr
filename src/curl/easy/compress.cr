class Curl::Easy
  enum Encoding
    GZIP
    DEFLATE
    ALL
  end

  protected def callback_compress!
    if compress
      case encoding
      when .all?
        curl_easy_setopt(curl, CURLOPT_ACCEPT_ENCODING, "")
      else
        curl_easy_setopt(curl, CURLOPT_ACCEPT_ENCODING, encoding.to_s.downcase)
      end
    end

    curl_easy_setopt(curl, CURLOPT_HTTP_CONTENT_DECODING, (decoding ? 1 : 0))
  end
end
