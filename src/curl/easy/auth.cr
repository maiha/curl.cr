class Curl::Easy
  enum Auth
    NONE
    BASIC
  end

  var auth_type : Auth = Auth::NONE
  var auth_userpwd : String
  
  def basic_auth(user : String, password : String)
    basic_auth("#{user}:#{password}")
  end

  def basic_auth(userpwd : String)
    self.auth_type = Auth::BASIC
    self.auth_userpwd = userpwd
  end

  protected def callback_auth!
    case auth_type?
    when .basic?
      userpwd = auth_userpwd? || raise Error.new("BUG: no credentials")
      curl_easy_setopt(curl, CURLOPT_USERPWD, userpwd)
      curl_easy_setopt(curl, CURLOPT_HTTPAUTH, CURLAUTH_BASIC)
    end
  end
end
