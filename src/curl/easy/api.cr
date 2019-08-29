class Curl::Easy
  protected def error_check!(code : Code, hint : String)
    code.curle_ok? || raise Error.new(code: code, hint: hint, uri: uri?)
  end

  # Defines handy methods for the native functions
  private macro api(name)
    def {{name.id}}(*args)
      hint = Error.hint("{{name.id}}", args)
      logger.debug hint
      _rv = ::LibCurl.{{name.id}}(*args)
      error_check!(_rv, hint)
    end

    # returns nil if no errors, otherwise returns the exception
    def {{name.id}}?(*args) : ::Curl::Error?
      {{name.id}}(*args)
      nil
    rescue err : ::Curl::Error
      err
    end
  end

  # NOP: just used for document generation
  private macro impl(name)
  end
  
  # Declare CURL methods explicitly for the case of printing backtraces
  impl curl_easy_init
  api  curl_easy_perform
  api  curl_easy_setopt
  api  curl_easy_cleanup
  api  curl_easy_getinfo

  # override `curl_easy_setopt` to embed values into logging
  def curl_easy_setopt(curl, name, value)
    logger.debug "setopt: #{name}, #{value.inspect}"
    _rv = ::LibCurl.curl_easy_setopt(curl, name, value)
    error_check!(_rv, hint: "curl_easy_setopt(#{name})")
  end
end
