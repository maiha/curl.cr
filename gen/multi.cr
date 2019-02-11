######################################################################
### automatically generate documents about `multi`
###
### [src]
###   - "curl/include/curl/multi.h"
###   - "src/curl/multi/api.cr"
### [dst]
###   - "doc/multi/list"
###   - "doc/multi/impl"
###   - "doc/multi.md"

require "pretty"

File.exists?("curl") || abort "'curl' sources not found. Please run 'make libcurl.a` first."


curl_header_path = "curl/include/curl/multi.h"
real_header_path = curl_header_path.sub(/^curl/, `readlink curl`.chomp)

# trim multilines that has trailing back-slash
buf = File.read(curl_header_path).gsub(/\\\n/, " ")
srcs = buf.split(/\n/)

record Define, name : String do
  def to_s(io : IO)
    io << "#{name}"
  end

  # CURL_EXTERN CURLM *curl_multi_init(void);
  # CURL_EXTERN const char *curl_multi_strerror(CURLMcode);
  def self.parse?(line : String) : Define?
    case line
    when /^CURL_EXTERN\s+.*?\b(curl_multi_.*?)\b/
      Define.new($1)
    else
      return nil
    end
  end
end

######################################################################
### parse

valid_definitions = Array(Define).new
giveup_messages   = Array(String).new

srcs.each do |line|
  if d = Define.parse?(line)
    valid_definitions << d
  end
end

######################################################################
### doc/multi/list

path = "doc/multi/list"
data = valid_definitions.map(&.name).join("\n")

File.write(path, data)
puts "created: '%s' (%d)" % [path, valid_definitions.size]

######################################################################
### doc/multi/impl

path  = "doc/multi/impl"
names = Array(String).new
File.read_lines("src/curl/multi/api.cr").each do |line|
  case line
  when /^\s*(api|impl)\s+([a-z0-9_]+)\s*$/
    names << $2
  end
end
data = names.join("\n")
File.write(path, data)
puts "created: '%s' (%d)" % [path, names.size]

