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
    multi.human_code_counts.should eq({"ERR" => 1, "200" => 2})
    multi.summary.should match(/^3 Requests/)
  end

  it "Enumerable raises when not finished" do
    multi = Curl::Multi.new
    multi << Curl::Easy.new("http://127.0.0.1:4/")

    expect_raises(Curl::NotFinished) do
      multi.each(&.to_s)
    end
  end
end
