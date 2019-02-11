class Curl::Multi::Error < Curl::Error
  var code : MCode
  var hint : String

  def initialize(msg : String)
    super(msg)
  end

  def initialize(@code : MCode, @hint : String? = nil)
    if v = code?
      super(Error.errmsg(v))
    else
      super(hint? || "error")
    end
  end

  def self.errmsg(code : MCode) : String
    String.new(LibCurlMulti.curl_multi_strerror(code))
  end
end  
