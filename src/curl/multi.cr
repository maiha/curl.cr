class Curl::Multi
end

require "./multi/*"

class Curl::Multi
  include Api
  include Enumerable(Easy::Response)

  ######################################################################
  ### Public variables

  var timeout    : Time::Span = 30.seconds
  var started_at : Time
  var stopped_at : Time

  var logger  = Logger.new(STDERR)
  var verbose = false

  # polling
  var polling_interval   = 0.seconds # 0.010.seconds
  var polling_timeout_ms = 1000
  
  ######################################################################
  ### Internal variables

  private var multi  : LibCurlMulti::Curlm*
  private var status : Status = Status::FREE

  private var requests  = Array(Easy).new
  private var responses = Array(Easy::Response).new

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
    status.free!
    
    requests << easy
    curl_multi_add_handle(multi, easy.curl)
    return self
  end

  def run(timeout : Time::Span? = nil)    
    status.free!

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
      # logger.debug "multi: found %d events" % numfds.value
      
      curl_multi_perform(multi, still_running)
      running = still_running.value
      break if running == 0
      logger.debug "multi: %d requests are running" % running if verbose

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
      responses << easy.response
    end
  end

  def each
    status.done!
    responses.each do |res|
      yield res
    end
  end

  def total_time : Time::Span
    if (t1 = started_at?) && (t2 = stopped_at?)
      t2 - t1
    else
      0.seconds
    end
  end

  def human_code_counts(default = "---") : Hash(String, Int32)
    counts = Hash(String, Int32).new
    each do |res|
      key = res.human_code(default)
      counts[key] = (counts[key]? || 0) + 1
    end
    return counts
  end
  
  def to_s(io : IO)
    case status
    when .done?
      each do |res|
        io.puts res.to_s
      end
    else
      requests.each do |easy|
        io.puts easy.to_s
      end
    end
  end
end
