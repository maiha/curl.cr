module Curl::Human
  abstract def status : Status
  abstract def info   : Info

  def human_code(default = nil) : String
    case status
    when .none? ; default || "---"
    when .run?  ; "RUN"
    when .done? ; (info.response_code == 0) ? "ERR" : info.response_code.to_s
    else        ; "BUG"         # enum error
    end
  end
end
