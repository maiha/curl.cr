class Curl::Multi
end

require "./multi/*"

class Curl::Multi
  include Api

  ######################################################################
  ### Internal variables

  var multi : LibCurlMulti::Curlm*
  property still_running : Pointer(Int32) = Pointer(Int32).malloc(1_u64)

  ######################################################################
  ### Public variables

  var requests = Array(Easy).new
  var timeout    : Time::Span = 30.seconds
  var interval   : Time::Span = 0.5.seconds
  var started_at : Time
  var stopped_at : Time

  var logger = Logger.new(STDERR)
  
  def initialize
    @multi = LibCurlMulti.curl_multi_init
    GC.add_finalizer(self)
  end

  def finalize
    LibCurlMulti.curl_multi_cleanup(multi)
  end

  def <<(easy : Easy) : Multi
    requests << easy
    easy.execute_before
    curl_multi_add_handle(multi, easy.curl)
    return self
  end

  def run(timeout : Time::Span? = nil)
    deadline = Time.now + (timeout || timeout())
    logger.debug "Multi: requests started (until: '#{deadline}')"

    self.started_at = Time.now
    while n = running?
      if Time.now > deadline
        self.stopped_at = Time.now
        msg = "Multi: execution timeouted (remain: #{n} requests)"
        logger.info msg
        raise IO::Timeout.new(msg)
      end
      logger.debug "Multi: #{n} requests are running."

      logger.debug "Multi: wait start"
      numfds = Pointer(Int32).malloc(1_u64)
      curl_multi_wait(multi, nil, 0, timeout.total_seconds, numfds)
      logger.debug "Multi: wait done (numfds=%d)" % numfds.value
    end
  end

  # return a number of the running requests, otherwise returns nil.
  def running? : Int32?
    curl_multi_perform(multi, @still_running)
    n = @still_running.value
    return (n > 0) ? n : nil
  end

  def total_time : Time::Span
    if (t1 = started_at?) && (t2 = stopped_at?)
      t2 - t1
    else
      0.seconds
    end
  end
end
