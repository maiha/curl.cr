class Curl::Easy
  var output_data : Output = Output.memory

  def output=(path : String)
    self.output_data = Output.file(path)
  end
end
