# with https://github.com/crystal-lang/crystal_lib
# ```console
# $ crystal src/main.cr -- lib_curl_multi.cr
# ```

@[Include("curl/multi.h", prefix: %w(curl_multi CURLM_), remove_prefix: false)]
lib LibCurlMulti
end
