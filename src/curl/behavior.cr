module Curl::Behavior
  protected def callback_behavior!
    curl_easy_setopt(curl, CURLOPT_HEADER , 1) if dump_header?
    curl_easy_setopt(curl, CURLOPT_VERBOSE, 1) if verbose?
  end
end
