class Curl::Easy
  var header_data : MemOutput = MemOutput.new

  protected def callback_header_data!
    func = ->(ptr : UInt8*, size : LibC::SizeT, nmemb : LibC::SizeT, data : Void*) {
      bytes = Bytes.new(ptr, size * nmemb)
      data.as(IO).write(bytes)
      size * nmemb
    }

    curl_easy_setopt(curl, CURLOPT_HEADERFUNCTION, func)
    curl_easy_setopt(curl, CURLOPT_HEADERDATA, header_data.as(Void*))
  end
end
