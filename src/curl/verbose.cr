module Curl::Verbose
  protected def callback_verbose!
    curl_easy_setopt!(CURLOPT_VERBOSE, 1) if verbose?
  end
end
