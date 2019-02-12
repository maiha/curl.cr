# Common interface for writing to either memory or file
abstract class Curl::Output < IO
  abstract def gets_to_end : String
  abstract def close : Nil
  abstract def file? : Bool
  abstract def memory? : Bool

  def self.memory
    Curl::MemOutput.new
  end

  def self.file(path : String)
    Curl::FileOutput.new(path)
  end
end

class Curl::MemOutput < Curl::Output
  var file   = false
  var memory = true
  var io : IO
  delegate read, write, to: io

  def initialize
    @io = IO::Memory.new
  end

  def gets_to_end : String
    io.rewind
    io.gets_to_end
  end

  def close
  end
end

class Curl::FileOutput < Curl::Output
  var file   = true
  var memory = false
  var io : IO
  delegate read, to: io

  var path   : String
  var status : Status = Status::FREE

  def initialize(@path : String)
  end

  def write(slice : Bytes) : Nil
    ensure_write!
    io.write(slice)
  end
  
  def gets_to_end : String
    File.read(path)
  end

  def close
    @io.try(&.close)
    @io = nil
  end

  protected def ensure_write!
    Dir.mkdir_p(File.dirname(path))
    @io ||= File.open(path, "w+")
  end
end
