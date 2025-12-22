# frozen_string_literal: true

require_relative "bgg_remote/version"
require_relative "bgg_remote/client"
require_relative "bgg_remote/api"

module BggRemote
  class Error < StandardError; end

  Config = Struct.new(:token, :timeout, :convert_to_hash, keyword_init: true)

  class << self
    attr_reader :api

    def configure
      config ||= Config.new
      yield config if block_given?

      client = Client.new(token: config.token, timeout: config.timeout)
      @api = Api.new(client, convert_to_hash: config.convert_to_hash)
    end
  end
end
