require "./spec_helper"

describe Curl do
  it "works" do
    curl = Curl::Easy.new("https://example.com")
    res  = curl.get
    res.success?.should be_true
    res.body.should contain("Example Domain")
  end

  it "Failed to connect to invalid server" do
    curl = Curl::Easy.new("http://127.0.0.1:4/")
    expect_raises(Curl::Error, /Failed to connect/) do
      curl.get
    end
  end
end
