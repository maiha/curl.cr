class Curl::Response
  var io : IO

  def initialize(@code : Int32, @io : IO)
  end

  def body : String
    io.rewind
    io.gets_to_end
  end

  def success? : Bool
    @code == 200
  end
end
