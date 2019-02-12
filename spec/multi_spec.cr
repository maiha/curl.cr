require "./spec_helper"

describe Curl::Multi do
  it "works" do
    multi = Curl::Multi.new
    multi << Curl::Easy.new("http://127.0.0.1:4/")
    multi << Curl::Easy.new("https://example.com")
    multi << Curl::Easy.new("https://github.com")
    multi.run(timeout: 10.seconds)

    # Enumerable(Easy::Response)
    multi.map(&.code).should eq([0, 200, 200])
    
    multi.to_s.chomp.should eq <<-EOF
      ERR http://127.0.0.1:4/
      200 https://example.com
      200 https://github.com
      EOF
  end

  it "Enumerable raises when not finished" do
    multi = Curl::Multi.new
    multi << Curl::Easy.new("http://127.0.0.1:4/")

    expect_raises(Curl::NotFinished) do
      multi.each(&.to_s)
    end
  end
end
