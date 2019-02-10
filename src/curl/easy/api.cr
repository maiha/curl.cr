class Curl::Easy
  protected def error_check!(code : Code, hint : String? = nil)
    code.curle_ok? || raise Error.new(code, hint, uri?)
  end

  # Defines handy methods for the native functions
  private macro api(name)
    # returns nil if no errors, otherwise returns the exception
    def {{name.id}}?(*args) : ::Curl::Error?
      {{name.id}}(*args)
      nil
    rescue err : ::Curl::Error
      err
    end

    def {{name.id}}(*args)
      _rv = ::Curl::Lib.{{name.id}}(*args)
      error_check!(_rv, "{{name.id}}")
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
end
