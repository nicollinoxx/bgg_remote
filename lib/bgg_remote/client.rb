require "httparty"
require_relative "errors"

class BggRemote::Client
  include HTTParty
  attr_reader :token, :timeout

  base_uri "https://boardgamegeek.com/xmlapi2"
  format :xml

  STATUS_CODES = {
    401 => BggRemote::Errors::Unauthorized,
    404 => BggRemote::Errors::NotFound,
    429 => BggRemote::Errors::RateLimited,
    500 => BggRemote::Errors::ServerError
  }.freeze

  def initialize(token: nil, timeout: 10)
    @token   = token
    @timeout = timeout
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
    error_class = STATUS_CODES.fetch(response.code, BggRemote::Error)
    raise error_class, "HTTP failed with code: #{response.code}, message #{response.message}"
  end
end
