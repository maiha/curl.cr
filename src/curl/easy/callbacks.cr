class Curl::Easy
  def after_execute
    @after_execute ||= [] of (->)
  end

  def after_execute(&callback : ->)
    after_execute << callback
  end

  def after_execute!
    after_execute.each(&.call)
    @after_execute = [] of (->)
  end
end
