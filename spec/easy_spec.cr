require "./spec_helper"

describe Curl::Easy do
  it "works" do
    curl = Curl::Easy.new("https://example.com")
    curl.connect_timeout = 3.seconds
    curl.timeout = 10.seconds
    curl.dump_header = true

    # info (before request)
    curl.info.response_code.should eq(0)
    curl.human_code.should eq("---")

    # execute
    res = curl.get

    # basic
    res.success?.should be_true
    res.code.should eq(200)
    res.body.should contain("Example Domain")
    res.header.should match /^HTTP.*200 OK/

    # output
    res.output.gets_to_end.should contain("Example Domain")

    # compats with HTTP::Client::Response
    http_res = res.response
    http_res.should be_a HTTP::Client::Response
    http_res.status_code.should eq(200)
    http_res.headers.should be_a HTTP::Headers
    http_res.headers["Content-Type"]?.should eq "text/html; charset=UTF-8"
    # shortcuts
    res.headers.should eq(http_res.headers)

    # info (after request)
    res.info.response_code      .should eq(200)
    res.info.http_version       .should eq(Curl::CURL_HTTP_VERSION_1_1.value)
    res.info.content_type       .should eq("text/html; charset=UTF-8")
    res.info.size_download      .should be_a(Float64)
    res.info.speed_download     .should be_a(Float64)
    res.info.namelookup_time    .should be_a(Float64)
    res.info.connect_time       .should be_a(Float64)
    res.info.appconnect_time    .should be_a(Float64)
    res.info.pretransfer_time   .should be_a(Float64)
    res.info.starttransfer_time .should be_a(Float64)
    res.info.total_time         .should be_a(Float64)
    res.info.redirect_time      .should be_a(Float64)

#    res.info.last_modified?     .should be_a(Time)
  end

  it "output to file" do
    path = "tmp/out1"
    File.delete(path) if File.exists?(path)

    curl = Curl::Easy.new("https://example.com")
    curl.output = path
    res = curl.get

    File.exists?(path).should be_true
    res.body.should contain("Example Domain")
    File.read(path).should contain("Example Domain")
  end
  
  it "301" do
    curl = Curl::Easy.new("http://github.com")
    curl.get.code.should eq(301)
  end
  
  it "Failed to connect to invalid server" do
    curl = Curl::Easy.new("http://127.0.0.1:4/")
    expect_raises(Curl::Easy::Error, /Failed to connect/) do
      curl.get
    end

    curl.to_s.should eq("RUN http://127.0.0.1:4/")
  end

  it "compiles to test variables" do
    curl = Curl::Easy.new("http://127.0.0.1:4/")
    curl.basic_auth("a:b")
    curl.compress = true
    curl.encoding = Curl::Easy::Encoding::ALL
    curl.encoding = Curl::Easy::Encoding::GZIP
    curl.encoding = Curl::Easy::Encoding::DEFLATE
    curl.decoding = false
    curl.output_data.memory?.should be_true
    curl.output = "index.html"
    curl.output_data.memory?.should be_false
  end
end
