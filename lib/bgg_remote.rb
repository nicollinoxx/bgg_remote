# frozen_string_literal: true

require_relative "bgg_remote/version"
require_relative "bgg_remote/error"
require_relative "bgg_remote/client"
require_relative "bgg_remote/api"

module BggRemote
  Config = Struct.new(:token, :timeout, :convert_to_hash, keyword_init: true)

  class << self
    attr_reader :api

    def configure
      config = Config.new(timeout: 10, convert_to_hash: true)
      yield config if block_given?

      client = Client.new(config.token, timeout: config.timeout)
      @api   = Api.new(client, convert_to_hash: config.convert_to_hash)
    end
  end
end
