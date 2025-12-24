require "httparty"

class BggRemote::Client
  include HTTParty
  attr_reader :token, :timeout

  base_uri "https://boardgamegeek.com/xmlapi2"
  format :xml

  STATUS_CODES = {
    401 => BggRemote::Error::Unauthorized,
    404 => BggRemote::Error::NotFound,
    429 => BggRemote::Error::RateLimited,
    500 => BggRemote::Error::ServerError,
    400 => BggRemote::Error::BadRequest,
    403 => BggRemote::Error::Forbidden,
    422 => BggRemote::Error::UnprocessableEntity
  }.freeze

  def initialize(token, timeout: nil)
    @token   = token
    @timeout = timeout || 10

    raise BggRemote::Error::MissingToken, "token is required" if token.nil?
  end

  def perform_request(path, **params)
    response = self.class.get("/#{path}", query: params.compact, headers: headers, timeout: timeout)

    raise_error_for(response) unless response.success?
    response.body
  end

  private

  def headers
    return { "Accept" => "application/xml" } unless token
    { "Accept" => "application/xml", "Authorization" => "Bearer #{token}" }
  end

  def raise_error_for(response)
    error_class = STATUS_CODES.fetch(response.code)
    raise error_class, "HTTP failed with code: #{response.code}, message #{response.message}"
  end
end
