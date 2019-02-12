class Curl::Easy::Response
  include Human

  var url    : String
  var status : Status
  var io     : IO
  var info   : Info
  var body   : String
  
  def initialize(@url : String, @status : Status, @info : Info, @io : IO)
    io.rewind
  end

  def code : Int32
    info.response_code
  end
  
  def body : String
    @body ||= (io.rewind; io.gets_to_end)
  end

  def success? : Bool
    code == 200
  end

  def to_s(io : IO)
    io << "%s %s %s" % [human_code, url, info]
  end
end
