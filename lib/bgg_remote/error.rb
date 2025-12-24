module BggRemote
  class Error < StandardError
    class Unauthorized        < Error; end
    class NotFound            < Error; end
    class ServerError         < Error; end
    class RateLimited         < Error; end
    class BadRequest          < Error; end
    class Forbidden           < Error; end
    class UnprocessableEntity < Error; end
    class XmlParseError       < Error; end
    class MissingToken        < Error; end
  end
end
