class Curl::Multi
end

require "./multi/*"

class Curl::Multi
  include Api

  record Result, url : String, code : Int32, info : Easy::Info

  ######################################################################
  ### Public variables

  var requests = Array(Easy).new
  var results  = Array(Result).new
  var timeout    : Time::Span = 30.seconds
  var started_at : Time
  var stopped_at : Time

  var logger = Logger.new(STDERR)

  # polling
  var polling_interval   = 0.seconds # 0.010.seconds
  var polling_timeout_ms = 1000
  
  ######################################################################
  ### Internal variables

  var multi : LibCurlMulti::Curlm*
  var status : Status = Status::NONE

  def initialize
    @multi = LibCurlMulti.curl_multi_init
    GC.add_finalizer(self)
  end

  def finalize
    LibCurlMulti.curl_multi_cleanup(multi)
  end

  ######################################################################
  ### Public methods

  def <<(easy : Easy) : Multi
    requests << easy
    curl_multi_add_handle(multi, easy.curl)
    return self
  end

  def run(timeout : Time::Span? = nil)    
    status.none? || raise Error.new("already executed. can't call 'run' twice")

    self.status = Status::RUN
    
    requests.each do |easy|
      easy.execute_before!
    end
    
    self.started_at = Time.now
    timeout ||= timeout()
    logger.debug "multi: started %d requests (timeout: %.3f sec)" % [requests.size, timeout.total_milliseconds/1000]

    still_running = Pointer(Int32).malloc(1_u64)
    curl_multi_perform(multi, still_running)

    deadline = started_at + timeout
    while true
      numfds = Pointer(Int32).malloc(1_u64)
      curl_multi_wait(multi, nil, 0, polling_timeout_ms, numfds)
      # numfds: being zero means either a timeout or no file descriptors to wait for
      logger.debug "multi: found %d events" % numfds.value
      
      curl_multi_perform(multi, still_running)
      running = still_running.value
      break if running == 0
      logger.debug "multi: still %d requests are running" % running

      if Time.now > deadline
        self.stopped_at = Time.now
        msg = "multi: execution timeouted (remain: %d requests)" % running
        logger.warn msg
        raise IO::Timeout.new(msg)
      end

      sleep polling_interval
    end

  ensure
    self.stopped_at = Time.now
    self.status = Status::DONE
    logger.debug "multi: finished %d requests (%.3f sec)" % [requests.size, total_time.total_milliseconds/1000]

    requests.each do |easy|
      easy.execute_after!
      info = easy.info
      results << Result.new(easy.url, info.response_code, info)
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

  def to_s(io : IO)
    requests.each do |easy|
      io.puts easy.to_s
    end
  end
end
