class Curl::Easy
  var output_data : Output = MemOutput.new

  def output=(path : String)
    self.output_data = FileOutput.new(path)
  end

  protected def callback_output!
    func = ->(ptr : UInt8*, size : LibC::SizeT, nmemb : LibC::SizeT, data : Void*) {
      bytes = Bytes.new(ptr, size * nmemb)
      data.as(IO).write(bytes)
      size * nmemb
    }
    
    curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, func)
    curl_easy_setopt(curl, CURLOPT_WRITEDATA, output_data.as(Void*))
  end
end
