module Curl::Execution
  def execute : Response
    # TODO: dry up callback feature
    callback_auth!
    callback_compress!
    callback_timeout!
    callback_verbose!
    
    execute_curl
  end

  def execute_curl : Response
    io = IO::Memory.new
    
    callback = ->(ptr : Void*, size : LibC::SizeT) {
      logger.debug "received data: #{size} Bytes"
      io.write(Slice.new(ptr.as(Pointer(UInt8)), size))
      size
    }
    boxed = Box.box(callback).as(Pointer(UInt8)) # box `callback` to `Void*`
    
    func = ->(contents : Void*, size : LibC::SizeT, nmemb : LibC::SizeT, _boxed : Void*) {
      cb = Box(typeof(callback)).unbox(_boxed.as(Pointer(Void))) # unbox `callback`
      cb.call(contents, size*nmemb)
    }
    
    curl_easy_setopt!(CURLOPT_WRITEFUNCTION, func)
    curl_easy_setopt!(CURLOPT_WRITEDATA, boxed)
    curl_easy_perform!

    io.rewind
    return Response.new(200, io)
  end
end
