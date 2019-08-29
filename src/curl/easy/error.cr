class Curl::Easy::Error < Curl::Error
  var code : Code

  def initialize(msg : String? = nil, @code : Code? = nil, hint : String? = nil, uri : URI? = nil)
    if code = code?
      case code
      when .curle_unknown_option?
        msg = Error.errmsg(code)
        if hint
          msg = "#{msg} [#{hint}]"
        end
      when .curle_couldnt_connect?
        host = uri.try(&.host)
        port = uri.try{|u| u.port || URI.default_port(u.scheme.to_s)} || 80
        msg = "(#{code.value}) Failed to connect #{host} port #{port}"
      end
    end

    msg ||= hint || "error"
    super(msg)
  end

  def self.errmsg(code : Code) : String
    String.new(LibCurl.curl_easy_strerror(code))
  end

  def self.hint(name : String, args : Tuple) : String
    # name: "curl_easy_getinfo"
    # args:  {Pointer(LibCurl::CURL)@0x563403706460, CURLINFO_RESPONSE_CODE, Pointer(Pointer(UInt8))@0x7f2a8363cfe0}]
    # args[0]: curl pointer
    # args[1]: key (CURLINFO_RESPONSE_CODE)
    # args[2]: val (...)

    hint = "#{name}(#{args.size})"
    if (args.size >= 2) && (args[0]?.is_a?(LibCurl::CURL*))
      case v = args[1]?
      when LibCurl::CURLcode, LibCurl::CURLoption, LibCurl::CURLINFO
        hint = "#{name}(#{v})"
      end
    end
    return hint
  end
end  
