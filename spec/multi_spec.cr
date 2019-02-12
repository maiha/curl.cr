require "./spec_helper"

describe Curl::Multi do
  it "works" do
    multi = Curl::Multi.new
    multi << Curl::Easy.new("http://127.0.0.1:4/")
    multi << Curl::Easy.new("https://example.com")
    multi << Curl::Easy.new("https://github.com")
    multi.run(timeout: 10.seconds)

    multi.to_s.chomp.should eq <<-EOF
      ERR http://127.0.0.1:4/
      200 https://example.com
      200 https://github.com
      EOF
  end
end
