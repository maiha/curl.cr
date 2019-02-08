require "./api"
require "./auth"
require "./compress"
require "./execution"

abstract class Curl::Base
  include Curl::Api
  include Curl::Auth
  include Curl::Compress
  include Curl::Execution

  var logger = Logger.new(STDERR)
  var uri : URI
  
  var dns_timeout     : Float64
  var connect_timeout : Float64
  var read_timeout    : Float64

  var compressed : Bool = false # Request compressed response
  
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
