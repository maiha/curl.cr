require "./spec_helper"

describe Curl do
  it "works" do
    curl = Curl::Easy.new("https://example.com")
    curl.connect_timeout = 3.seconds
    curl.timeout = 10.seconds
    curl.dump_header = true
    
    res = curl.get

    # basic
    res.success?.should be_true
    res.code.should eq(200)
    res.body.should contain("Example Domain")

    # IO
    res.io.should be_a(IO)
    res.io.rewind
    res.io.gets_to_end.should contain("Example Domain")

    # info
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
  end

  it "301" do
    curl = Curl::Easy.new("http://github.com")
    curl.get.code.should eq(301)
  end
  
  it "Failed to connect to invalid server" do
    curl = Curl::Easy.new("http://127.0.0.1:4/")
    curl.basic_auth("a:b")
    expect_raises(Curl::Easy::Error, /Failed to connect/) do
      curl.get
    end
  end
end
