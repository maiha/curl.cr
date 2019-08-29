class Curl::Easy::Response
  include Human

  var url    : String
  var status : Status
  var header : String
  var output : Output
  var info   : Info

  # compats with HTTP::Client::Response
  var response : HTTP::Client::Response = build_response

  def initialize(@url : String, @status : Status, @info : Info, @header : String, @output : Output)
  end

  def code : Int32
    info.response_code
  end

  def body : String
    output.gets_to_end
  end

  def success? : Bool
    code == 200
  end

  def to_s(io : IO)
    io << "%s %s %s" % [human_code, url, info]
  end

  ######################################################################
  ### compats with HTTP::Client::Response

  delegate headers, to: response

  # header
  # ```text
  # HTTP/1.1 200 OK
  # Content-Encoding: gzip
  # ...
  # ```
  
  def build_response
    io = IO::Memory.new
    io.print header
    io.rewind

    # stdlib(HTTP::Client::Response) sometimes raises when parsing body
    # So, use it for just parsing headers, then composes with our objects.

    # 1. parse headers
    headers = HTTP::Client::Response.from_io(io, ignore_body: true, decompress: false).headers

    # 2. compose with our objects
    return HTTP::Client::Response.new(code, body, headers)
  end
end
