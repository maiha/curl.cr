class Curl::Easy::Response
  include Human

  var url    : String
  var status : Status
  var output : Output
  var info   : Info
  
  def initialize(@url : String, @status : Status, @info : Info, @output : Output)
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
end
