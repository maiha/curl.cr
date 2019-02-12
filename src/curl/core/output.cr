# Common interface for writing to either memory or file
abstract class Curl::Output < IO
  # `Easy::Response#body` requires all data as `String`.
  abstract def gets_to_end : String

  # `Easy#execute_before` fires this
  abstract def begin : Nil

  # `Easy#execute_after` fires this
  abstract def commit : Nil

  # `Easy#execute_after` fires this
  abstract def abort : Nil

  # Whether is this io is file-based or in-memory?
  abstract def file? : Bool
  abstract def memory? : Bool
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

  def begin
  end

  def commit
  end

  def abort
  end
end

class Curl::FileOutput < Curl::Output
  var file   = true
  var memory = false
  var io_tmp : IO

  var path   : String
  var tmp    : String
  var status : Status = Status::FREE

  def initialize(@path : String)
    self.tmp = "#{path}.tmp"
  end

  def read(slice : Bytes) : Nil
    raise NotImplementedError.new("[BUG] #{self.class.name}#read should not be called.")
  end
  
  def write(slice : Bytes) : Nil
    io_tmp.write(slice)
  end
  
  def gets_to_end : String
    File.read(path)
  end

  def begin
    ensure_write!
  end

  def commit
    if io = io_tmp?
      io.close
      File.rename(tmp, path)
      @io_tmp = nil
    end
  end

  def abort
  end

  protected def ensure_write!
    File.delete(path) if File.exists?(path)
    Dir.mkdir_p(File.dirname(tmp))
    @io_tmp ||= File.open(tmp, "w+")
  end
end
