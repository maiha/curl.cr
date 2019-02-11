class Curl::Easy
  # IMPORTANT: value must be integer format since 'setopt' doesn't check validity.
  protected def callback_timeout!
    if v = connect_timeout?
      v = v.total_milliseconds.ceil.to_i64
      curl_easy_setopt(curl, CURLOPT_CONNECTTIMEOUT_MS, v)
    end

    if v = timeout?
      v = v.total_milliseconds.ceil.to_i64
      curl_easy_setopt(curl, CURLOPT_TIMEOUT_MS, v)
    end
  end
end
