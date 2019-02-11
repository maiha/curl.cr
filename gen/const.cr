######################################################################
### automatically generate `LibCurlConst`
###
### [src]
###   - "curl/include/curl/curl.h"
### [dst]
###   - "src/lib_curl_const.cr"
###   - "doc/const/list"

require "../curl"

File.exists?("curl") || abort "'curl' sources not found. Please run 'make libcurl.a` first."

curl_header_paths = ["curl/include/curl/curl.h", "curl/include/curl/multi.h"]
real_header_paths = curl_header_paths.map(&.sub(/^curl/, `readlink curl`.chomp))

# trim multilines that has trailing back-slash
buf = String.build do |s|
  real_header_paths.each do |path|
    s << File.read(path).gsub(/\\\n/, " ")
  end
end
srcs = buf.split(/\n/)

valid_definitions   = Array(Define).new
giveup_messages = Array(String).new

record Define, key : String, val : String, comment : String do
  def prefix
    key.sub(/_.*$/, "")
  end
  
  def to_a
    [key, " = ", val, comment]
  end

  def to_s(io : IO)
    io << "#{key} #{val} #{comment}"
  end

  def self.parse(key, val, commentable)
    val = val.gsub(/\(unsigned long\)/, "").sub(/(\d+)L$/){$1}
    if v = commentable
      v = v.sub(%r{^/\*},"").sub(%r{\*/\s*$},"").strip
      comment = " # #{v}"
    else
      comment = ""
    end
    new(key, val, comment)
  end
end

def grouping_by_prefix(defines : Array(Define)) : Array(Array(Define))
  results = Array(Array(Define)).new

  stack = Array(Define).new
  current_prefix = ""

  defines.each do |define|
    if current_prefix != define.prefix
      if stack.any?
        results << stack
        stack = Array(Define).new
      end
      current_prefix = define.prefix
    end

    stack << define
  end
  if stack.any?
    results << stack
  end
  return results
end

# temporary parsed definitions
consts = Hash(String, Array(Define)).new

srcs.each do |src|
  # src: "#define CURLSSH_AUTH_ANY   ~0  /* all types supported by the server */"
  # dst: ["CURLSSH_AUTH_ANY", " = ", "~0", " # all types supported by the server"]
  case src
  when %r{^#define (CURL[A-Z0-9_]+)\s+(.*?)(/\*.*)?$}
    consts[$1] ||= Array(Define).new
    consts[$1] << Define.parse($1, $2, $3?)
  when /^#define CURL[^\s]+ /
    STDERR.puts "miss: #{src.inspect}"
  end
end

# find duplicated entry caused by such as `ifdef`
# [valid]   `valid_definitions`
# [invalid] `giveup_messages`

consts.each do |k, ary|
  if ary.size == 1
    valid_definitions << ary.first
  else
    giveup_messages << "found '#{k}' has #{ary.size} definitions"
    giveup_messages.concat(ary.map(&.to_s))
  end
end

######################################################################
### from enums

enum_consts = Array(String).new
{% for member in LibCurl::CURLoption.constants %}
  enum_consts << "{{member}}"
{% end %}

######################################################################
### doc/const/list

path  = "doc/const/list"
names = LibCurlSymbols::CurlSymbols.map(&.name)
data  = names.join("\n")

File.write(path, data)
puts "created: '%s' (%d)" % [path, names.size]

######################################################################
### doc/const/impl

path = "doc/const/impl"
data = `grep -rv '^[ ]*#' src/curl | grep -oP 'CURL[A-Z0-9_]+' | sort | uniq`

File.write(path, data)
puts "created: '%s' (%d)" % [path, data.count("\n")]

######################################################################
### src/lib_curl_const.cr

path = "src/lib_curl_const.cr"
data = String.build do |s|
  s.puts "# This file is managed by 'gen/const.cr'. Do not edit."
  s.puts "#"
  real_header_paths.each do |path|
    s.puts "# src: https://github.com/curl/curl/blob/#{path}"
  end
  s.puts "#"
  s.puts "# Run 'make gen' to update"
  s.puts "#"
  s.puts "module LibCurlConst"

  # first, write giveup_messages
  giveup_messages.each do |line|
    s.puts "  # #{line}"
  end

  # then, write valid definitions in grouped by prefix string
  grouped = grouping_by_prefix(valid_definitions)
  grouped.each do |defines|
    s.puts ""
    s.puts Pretty.lines(defines.map(&.to_a), indent: "  ")
  end
  s.puts "end"
end

File.write(path, data)
puts "created: '#{path}'"
