require "./api"
require "./auth"
require "./compress"
require "./execution"
require "./timeout"
require "./verbose"

abstract class Curl::Base
  include Curl::Api
  include Curl::Auth
  include Curl::Compress
  include Curl::Execution
  include Curl::Timeout
  include Curl::Verbose

  var logger = Logger.new(STDERR)
  var uri : URI
  
  var timeout         : Time::Span
  var connect_timeout : Time::Span

  var compressed = false # Request compressed response
  var verbose    = false # Set verbose mode

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
  
  def self.new(uri : URI) : Curl::Easy
    new.tap(&.uri = uri)
  end

  def self.new(url : String) : Curl::Easy
    new(URI.parse(url))
  end
end
