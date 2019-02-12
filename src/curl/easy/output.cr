class Curl::Easy
  var output_data : Output = MemOutput.new

  def output=(path : String)
    self.output_data = FileOutput.new(path)
  end
end
