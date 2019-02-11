private macro info(assign)
  {% symbol  = assign.target %}
  {% value   = assign.value %}
  {% type    = (value.class_name == "TupleLiteral") ? value[0] : value %}
  {% default = (value.class_name == "TupleLiteral") ? value[1] : nil %}
  {% stype   = type.stringify %}
  {% name    = symbol.stringify.downcase.gsub(/^curl/, "").id %}

  {% if stype == "String" %}
    protected def {{name}}
      ptr = Pointer(Pointer(UInt8)).malloc(1_u64)
      curl_easy_getinfo(curl, {{symbol}}, ptr)
      if !ptr.value.null?
        return String.new(ptr.value)
      else
        return ""
      end
    end
  {% else %}       
    protected def {{name}}
      v = Pointer({{type}}).malloc(1_u64)
      curl_easy_getinfo(curl, {{symbol}}, v)
      {% if    stype == "Int32"   %} v.value.to_i32
      {% elsif stype == "Int64"   %} v.value.to_i64
      {% elsif stype == "Float64" %} v.value.to_f64
      {% else                     %} v.value
      {% end %}
    end
  {% end %}
end

class Curl::Easy
  class Info
    var response_code      : Int32
    var http_version       : Int64
#    var filetime           : Int64
    var size_download      : Float64
    var speed_download     : Float64
    var content_type       : String
    
    var namelookup_time    : Float64
    var connect_time       : Float64
    var appconnect_time    : Float64
    var pretransfer_time   : Float64
    var starttransfer_time : Float64
    var total_time         : Float64
    var redirect_time      : Float64

    def last_modified? : Time?
      if filetime >= 0
        Time.new(seconds: filetime, nanoseconds: 0, location: Time::Location.local)
      else
        nil
      end
    end

    def times_overview : String
      String.build do |s|
        s.puts "(%.3fs) |--NAMELOOKUP" % namelookup_time
        s.puts "(%.3fs) |--|--CONNECT" % connect_time
        s.puts "(%.3fs) |--|--|--APPCONNECT" % appconnect_time
        s.puts "(%.3fs) |--|--|--|--PRETRANSFER" % pretransfer_time
        s.puts "(%.3fs) |--|--|--|--|--STARTTRANSFER" % starttransfer_time
        s.puts "(%.3fs) |--|--|--|--|--|--TOTAL" % total_time
        s.puts "(%.3fs) |--|--|--|--|--|--REDIRECT" % redirect_time
      end.chomp
    end
  end

  protected def build_info : Info
    i = Info.new
    i.response_code      = info_response_code
    i.http_version       = info_http_version
#    i.filetime           = info_filetime
    i.size_download      = info_size_download
    i.speed_download     = info_speed_download
    i.content_type       = info_content_type
    i.namelookup_time    = info_namelookup_time
    i.connect_time       = info_connect_time
    i.appconnect_time    = info_appconnect_time
    i.pretransfer_time   = info_pretransfer_time
    i.starttransfer_time = info_starttransfer_time
    i.total_time         = info_total_time
    i.redirect_time      = info_redirect_time
    i
  end

  info CURLINFO_RESPONSE_CODE      = Int32
  info CURLINFO_HTTP_VERSION       = Int64
#  info CURLINFO_FILETIME           = Int64 # {Int64, -1}
  info CURLINFO_SIZE_DOWNLOAD      = Float64
  info CURLINFO_SPEED_DOWNLOAD     = Float64
  info CURLINFO_CONTENT_TYPE       = String

  info CURLINFO_NAMELOOKUP_TIME    = Float64
  info CURLINFO_CONNECT_TIME       = Float64
  info CURLINFO_APPCONNECT_TIME    = Float64
  info CURLINFO_PRETRANSFER_TIME   = Float64
  info CURLINFO_STARTTRANSFER_TIME = Float64
  info CURLINFO_TOTAL_TIME         = Float64
  info CURLINFO_REDIRECT_TIME      = Float64

  # # pending: I don't know why `v.value` is always `-1` here.
  # def info_filetime
  #   v = Pointer(Int64).malloc(1_u64)
  #   curl_easy_getinfo(curl, CURLINFO_FILETIME, v)
  #   v.value
  # end
end
