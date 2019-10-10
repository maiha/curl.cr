require "../spec_helper"

private class Httpbin
  JSON.mapping({
    data: String?,
    form: Hash(String, String)?,
    headers: Hash(String, String)?,
  })
end

private def extract!(res) : Httpbin
  res.success?.should be_true
  res.code.should eq(200)
  json = Httpbin.from_json(res.body)
ensure
  if json.nil?
    puts res.body
  end
end

private def curl
  curl = Curl::Easy.new("http://httpbin.org/post")
  curl.connect_timeout = 1.seconds
  curl.timeout = 2.seconds
  curl
end

describe "Curl::Easy#post" do
  it "works with body" do
    res = curl.post(body: "foo=1")
    extract!(res).data.should eq("foo=1")
  end

  it "works with json" do
    res = curl.post(json: {"foo" => "bar"})
    extract!(res).data.should eq(%Q({"foo":"bar"}))
  end

  it "works with form" do
    res = curl.post(form: {"foo" => "bar"})
    extract!(res).form.should eq({"foo" => "bar"})
  end
end
