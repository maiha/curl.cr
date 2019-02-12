require "./easy/*"

class Curl::Easy
  ######################################################################
  ### Public variables

  var uri      : URI
  var logger   : Logger   = Logger.new(STDERR)
  var response : Response = build_response
  var info     : Info     = build_info

  # behavior
  var dump_header = false # Pass headers to the data stream
  var verbose     = false # Set verbose mode
  
  var timeout         : Time::Span
  var connect_timeout : Time::Span

  var compressed = false # Request compressed response

  ######################################################################
  ### Public methods

  def port : Int32
    uri?.try{|u| u.port || URI.default_port(u.scheme.to_s)} || 80
  end

  def uri=(url : String)
    update_uri!(url)
  end

  def get(path : String? = nil) : Response
    update_uri!(path)
    return execute
  end
  
  def self.new(uri : URI) : Curl::Easy
    new.tap(&.uri = uri)
  end

  def self.new(url : String) : Curl::Easy
    new(URI.parse(url))
  end

  ######################################################################
  ### Internal

  enum Status
    NONE
    RUN
    DONE
  end
  
  var curl : LibCurl::CURL*
  var status : Status = Status::NONE
  var userdata = IO::Memory.new
    
  def initialize
    @curl = LibCurl.curl_easy_init
    GC.add_finalizer(self)
  end

  def finalize
    LibCurl.curl_easy_cleanup(curl)
  end

  protected def update_status!(status : Status)
    # clear variables that related to status
    @response = nil
    @info     = nil
  end

  protected def update_uri!(path : String? = nil)
    case path
    when %r{\Ahttp(s?)://}
      self.uri = URI.parse(path.to_s)
    when /^([^:]+):(\d+)/
      self.uri = URI.parse("http://#{path}")
    when %{^/}
      uri.path = path
    when String
      raise Error.new("invalid url: '#{path}'")
    else
      # ignore nil for the case of `curl.get`
    end
  end
  
  ######################################################################
  ### testing
  def testing_sample!(url : String)
    self.uri = url
    curl_easy_setopt(curl, CURLOPT_HEADER, 0)
    curl_easy_setopt(curl, CURLOPT_URL, url)
    curl_easy_setopt(curl, CURLOPT_PRIVATE, url)
    curl_easy_setopt(curl, CURLOPT_VERBOSE, 0)
    curl_easy_setopt(curl, CURLOPT_CONNECTTIMEOUT_MS, 2000)
  end
end
