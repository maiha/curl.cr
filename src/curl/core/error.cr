class Curl::Error < Exception
end

class Curl::NotFinished < Curl::Error
end

class Curl::AlreadyRunning < Curl::Error
end
