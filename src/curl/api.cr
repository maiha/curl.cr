module Curl::Api
  # Automatically create instances with initial access
  var curl : Lib::CURL* = Lib.curl_easy_init

  protected def error_check!(code : Code, hint : String? = nil)
    code.curle_ok? || raise Error.new(code, hint, uri?)
  end

  # Defines handy methods for the native functions
  private macro api(name)
    def {{name.id}}(*args)
      ::Curl::Lib.{{name.id}}(curl, *args)
    end

    def {{name.id}}!(*args)
      _rv = ::Curl::Lib.{{name.id}}(curl, *args)
      error_check!(_rv, "{{name.id}}")
    end
  end

  # Declare CURL methods explicitly for the case of printing backtraces
  api curl_easy_perform
  api curl_easy_setopt
    
  abstract def get(path : String? = nil) : Response
  abstract def cleanup
end
