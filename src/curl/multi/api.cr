module Curl::Multi::Api
  protected def error_check!(code : MCode, hint : String? = nil)
    code.curlm_ok? || raise Error.new(code, hint)
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
      _rv = ::LibCurlMulti.{{name.id}}(*args)
      error_check!(_rv, "{{name.id}}")
    end
  end

  # NOP: just used for document generation
  private macro impl(name)
  end
  
  # Declare CURL methods explicitly for the case of printing backtraces
  impl curl_multi_init
  api  curl_multi_add_handle
  api  curl_multi_perform
  api  curl_multi_cleanup
  api  curl_multi_wait
  api  curl_multi_setopt
end
