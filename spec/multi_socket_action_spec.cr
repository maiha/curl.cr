require "./spec_helper"

describe Curl::Multi::SocketAction do
  pending "works" do
    easy1 = Curl::Easy.new("https://example.com")
    multi = Curl::Multi::SocketAction.new
    # TODO
  end
end
