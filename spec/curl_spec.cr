require "./spec_helper"

describe Curl do
  it "works" do
    curl = Curl::Easy.new("https://example.com")
    curl.connect_timeout = 3.seconds
    curl.timeout = 10.seconds

    res = curl.get
    res.success?.should be_true
    res.body.should contain("Example Domain")
    res.io.should be_a(IO)
    res.io.rewind
    res.io.gets_to_end.should contain("Example Domain")
  end

  it "Failed to connect to invalid server" do
    curl = Curl::Easy.new("http://127.0.0.1:4/")
    expect_raises(Curl::Error, /Failed to connect/) do
      curl.get
    end
  end
end
