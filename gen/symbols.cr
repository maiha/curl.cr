######################################################################
### automatically generate `LibCurlConst`
###
### [src]
###   - "curl/docs/libcurl/symbols-in-versions"
### [dst]
###   - "src/lib_curl_symbols.cr"

require "pretty"

File.exists?("curl") || abort "'curl' sources not found. Please run 'make libcurl.a` first."

curl_path = "curl/docs/libcurl/symbols-in-versions"
real_path = curl_path.sub(/^curl/, `readlink curl`.chomp)
sources   = File.read_lines(curl_path)

######################################################################
### parse

symbols = Array(Array(String)).new

sources.each do |line|
  # Name                           Introduced  Deprecated  Removed
  # CURLOPT_HTTPPOST                7.1           7.56.0
  # CURLOPT_HTTPPROXYTUNNEL         7.3
  # CURLOPT_HTTPREQUEST             7.1           -           7.15.5
  case line
  when /^CURL/
    a = (line.split(/\s+/) + ["", "", ""])
    symbols << a[0..3]
  end
end

######################################################################
### src/lib_curl_symbols.cr

path = "src/lib_curl_symbols.cr"
data = String.build do |io|
  io.puts <<-EOF
    # This file is managed by 'gen/symbols.cr'. Do not edit.
    #
    # src: https://github.com/curl/curl/blob/#{real_path}
    #
    # Run "make gen" to update
    #

    module LibCurlSymbols
      def self.each
        CurlSymbols.each{|s| yield s}
      end

      def self.[](name : String)
        self[name]? || raise ArgumentError.new("no symbols for '%s'" % name)
      end

      def self.[]?(name : String)
        name = name.upcase
        each do |s|
          return s if s.name == name
        end
        return nil
      end

      record CurlSymbol,
        name       : String, 
        introduced : String,
        deprecated : String,
        removed    : String do

        def to_s(io : IO)
          v = String.build do |s|
            s << introduced
            s << "-"
            s << deprecated
            s << removed
          end
          io << name.to_s
          io << "(" << v << ")" if v != "-"
        end
      end

      CurlSymbols = [
    EOF
  
  lines = Array(Array(String)).new
  symbols.each do |ary|
    lines << ["#{ary[0].inspect}", "#{ary[1].inspect}",  "#{ary[2].inspect}",  "#{ary[3].inspect}"]
  end
  Pretty.lines(lines, delimiter: ", ").split(/\n/).each do |line|
    io.puts "    CurlSymbol.new(#{line}),"
  end
  io.puts "  ]"
  io.puts "end"
end

File.write(path, data)
puts "created: '%s' (%d)" % [path, sources.size]
