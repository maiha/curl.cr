require "./spec_helper"

describe Curl::Multi do
  it "works" do
    easy1 = Curl::Easy.new("https://example.com")
    easy2 = Curl::Easy.new("https://github.com")

    multi = Curl::Multi.new
    multi << easy1
    multi << easy2
    multi.run(timeout: 10.seconds)

    multi.requests.each do |easy|
      puts "debug times"
      puts easy.response.info.times_overview
    end

    multi.requests.map(&.response.code).uniq.should eq([200])
  end
end
