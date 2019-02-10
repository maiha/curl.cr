private macro info(assign)
  {% symbol = assign.target %}
  {% type   = assign.value %}
  {% name = symbol.stringify.downcase.gsub(/^curl/, "").id %}

  protected def {{name}}
    v = Pointer({{type}}).malloc(1_u64)
    curl_easy_getinfo(curl, {{symbol}}, v)
    {% if    type.stringify == "Int32"   %} v.value.to_i32
    {% elsif type.stringify == "Int64"   %} v.value.to_i64
    {% elsif type.stringify == "Float64" %} v.value.to_f64
    {% else                              %} v.value
    {% end %}
  end
end

class Curl::Easy
  class Info
    var response_code      : Int32
    var http_version       : Int64
    var size_download      : Float64
    var speed_download     : Float64
    
    var namelookup_time    : Float64
    var connect_time       : Float64
    var appconnect_time    : Float64
    var pretransfer_time   : Float64
    var starttransfer_time : Float64
    var total_time         : Float64
    var redirect_time      : Float64

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
    i.size_download      = info_size_download
    i.speed_download     = info_speed_download
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
  info CURLINFO_SIZE_DOWNLOAD      = Float64
  info CURLINFO_SPEED_DOWNLOAD     = Float64

  info CURLINFO_NAMELOOKUP_TIME    = Float64
  info CURLINFO_CONNECT_TIME       = Float64
  info CURLINFO_APPCONNECT_TIME    = Float64
  info CURLINFO_PRETRANSFER_TIME   = Float64
  info CURLINFO_STARTTRANSFER_TIME = Float64
  info CURLINFO_TOTAL_TIME         = Float64
  info CURLINFO_REDIRECT_TIME      = Float64
end
