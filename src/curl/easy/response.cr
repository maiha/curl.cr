class Curl::Easy::Response
  var io   : IO
  var body : String
  var info : Info

  def initialize(@io : IO, @info : Info)
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
end
