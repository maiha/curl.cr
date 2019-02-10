class Curl::Response
  var code : Int32
  var io   : IO
  var body : String

  def initialize(@code : Int32, @io : IO)
    io.rewind
  end

  def body : String
    @body ||= (io.rewind; io.gets_to_end)
  end

  def success? : Bool
    @code == 200
  end
end
