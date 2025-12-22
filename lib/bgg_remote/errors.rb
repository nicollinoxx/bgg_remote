module BggRemote::Errors
  class Error < StandardError; end

  class Unauthorized < Error; end
  class NotFound     < Error; end
  class ServerError  < Error; end
  class Timeout      < Error; end
  class RateLimited  < Error; end
end
