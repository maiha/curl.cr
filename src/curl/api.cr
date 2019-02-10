module Curl::Api
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

  # NOP: just used for document generation
  private macro impl(name)
  end
  
  # Declare CURL methods explicitly for the case of printing backtraces
  impl curl_easy_init
  api  curl_easy_perform
  api  curl_easy_setopt
  api  curl_easy_cleanup

  abstract def get(path : String? = nil) : Response
  abstract def cleanup
end
