require "./easy/*"

class Curl::Easy
  # Automatically create instances with initial access
  private var curl : Lib::CURL* = Lib.curl_easy_init

  var logger = Logger.new(STDERR)
  var uri : URI

  # behavior
  var dump_header = false # Pass headers to the data stream
  var verbose     = false # Set verbose mode
  
  var timeout         : Time::Span
  var connect_timeout : Time::Span

  var compressed = false # Request compressed response

  def port : Int32
    uri?.try{|u| u.port || URI.default_port(u.scheme.to_s)} || 80
  end

  def uri=(url : String)
    update_uri!(url)
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
  
  def get(path : String? = nil) : Response
    update_uri!(path)
    curl_easy_setopt(curl, CURLOPT_URL, uri.to_s)
    return execute
  ensure
    cleanup
  end
  
  protected def cleanup
    if _curl = curl?
      Lib.curl_easy_cleanup(_curl)
    end
  end

  def self.new(uri : URI) : Curl::Easy
    new.tap(&.uri = uri)
  end

  def self.new(url : String) : Curl::Easy
    new(URI.parse(url))
  end
end
