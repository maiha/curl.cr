class Curl::Error < Exception
  var code : Code
  var hint : String
  var uri  : URI

  def initialize(msg : String)
    super(msg)
  end

  def initialize(@code : Code, @hint : String? = nil, @uri : URI? = nil)
    if v = code?
      super(build_code_message(v))
    else
      super(hint? || "error")
    end
  end

  def build_code_message(code : Code) : String
    case code
    when .curle_couldnt_connect?
      host = uri?.try(&.host)
      port = uri?.try{|u| u.port || URI.default_port(u.scheme.to_s)} || 80
      return "(#{code.value}) Failed to connect #{host} port #{port}"
    end

    return Error.errmsg(code)
  end

  def self.errmsg(code : Code) : String
    String.new(Lib.curl_easy_strerror(code))
  end
end  
