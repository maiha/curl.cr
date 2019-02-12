require "./info"

class Curl::Easy
  def execute : Response
    execute_before
    execute_main
    execute_after
    return response
  end

  # must ensure idempotency
  def execute_before
    curl_easy_setopt(curl, CURLOPT_URL, uri.to_s)

    # TODO: dry up callback feature
    callback_auth!
    callback_behavior!
    callback_compress!
    callback_timeout!

    callback = ->(ptr : Void*, size : LibC::SizeT) {
      logger.debug "received data: #{size} Bytes" if verbose?
      userdata.write(Slice.new(ptr.as(Pointer(UInt8)), size))
      size
    }
    boxed = Box.box(callback).as(Pointer(UInt8)) # box `callback` to `Void*`
    
    func = ->(contents : Void*, size : LibC::SizeT, nmemb : LibC::SizeT, _boxed : Void*) {
      cb = Box(typeof(callback)).unbox(_boxed.as(Pointer(Void))) # unbox `callback`
      cb.call(contents, size*nmemb)
    }
    
    curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, func)
    curl_easy_setopt(curl, CURLOPT_WRITEDATA, boxed)
  end

  def execute_main
    update_status!(Status::RUN)
    curl_easy_perform(curl)
  end

  def execute_after
    update_status!(Status::DONE)
  end

  private def build_response : Response
    logger.debug "TIMES overview\n%s" % info.times_overview
    logger.debug "Downloaded %s" % Pretty.bytes(info.size_download.ceil)
    logger.debug "Download speed %s/sec" % Pretty.bytes(info.speed_download.ceil)

    userdata.rewind
    return Response.new(userdata, info)
  end
end
