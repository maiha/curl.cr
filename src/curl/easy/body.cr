class Curl::Easy
  protected def callback_body!
    case method
    when .post?
      if !body.empty?
        curl_easy_setopt(curl, CURLOPT_POSTFIELDS, body)
      end
    end
  end
end
