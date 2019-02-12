require "option_parser"
require "../src/curl"

begin
  curl = Curl::Easy.new
  curl.logger.level = Logger::Severity::INFO

  parser = OptionParser.new
  parser.on("-u=<user:password>", "Server user and password") {|v| curl.basic_auth(v)}
  parser.on("--connect-timeout=<seconds>", "Maximum time allowed for connection") {|v| curl.connect_timeout = v.to_i32.seconds}
  parser.on("--timeout=<seconds>", "Maximum time allowed for timeout") {|v| curl.timeout = v.to_i32.seconds}
  parser.on("--encoding=<enc>", "One of 'all', 'gzip', 'deflate'") {|v| curl.encoding = Curl::Easy::Encoding.parse(v)}
  parser.on("--no-decoding", "Disable automatic decompression") { curl.decoding = false }
  parser.on("--dump-header", "Pass headers to the data stream") { curl.dump_header = true }
  parser.on("-v", "set verbose output") { curl.verbose = true }
  parser.on("-d", "debug mode") { curl.logger.level = Logger::Severity::DEBUG }
  parser.parse!
 
  curl.uri = ARGV.shift? || raise ArgumentError.new("URL not found")
  multi = Curl::Multi.new
  multi.logger = curl.logger
  multi << curl
  multi.run(timeout: curl.timeout?)

  multi.requests.each do |easy|
    STDERR.puts "%s %s" % [easy, easy.info]
  end
  print curl.response.body

rescue err  
  if err.is_a?(ArgumentError)
    STDERR.puts "Usage: crurl <url>"
    if _parser = parser
      STDERR.puts _parser
    end
  end

  abort err.to_s
end
