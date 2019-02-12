enum Curl::Status
  FREE
  RUN
  DONE

  def free!
    free? || raise AlreadyRunning.new("Already running (#{to_s}")
  end

  def done!
    done? || raise NotFinished.new("Not finished yet (#{to_s}")
  end
end
