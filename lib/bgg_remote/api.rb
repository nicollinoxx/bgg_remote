# frozen_string_literal: true
require "active_support"
require "active_support/core_ext/hash/conversions"
require "active_support/core_ext/hash/keys"

class BggRemote::Api
  attr_accessor :convert_to_hash

  def initialize(client, convert_to_hash: true)
    @client          = client
    @convert_to_hash = convert_to_hash
  end

  def thing(id:, **params)
    request("thing", id: id, **params)
  end

  def family(id:, type: nil)
    request("family", id: id, type: type)
  end

  def forum_list(id:, type: nil)
    request("forumlist", id: id, type: type)
  end

  def forum(id:, page: nil)
    request("forum", id: id, page: page)
  end

  def thread(id:, **params)
    request("thread", id: id, **params)
  end

  def user(name:, **params)
    request("user", name: name, **params)
  end

  def guild(id:, **params)
    request("guild", id: id, **params)
  end

  def search(query:, **params)
    request("search", query: query, **params)
  end

  def plays(username: nil, id: nil, type: nil, **params)
    validate_required_one_of!(username: username, id: id)

    request("plays", username: username, id: id, type: type, **params)
  end

  def hot_items(type:)
    request("hot", type: type)
  end

  def collection(username:, **params)
    request("collection", username: username, **params)
  end

  private

  def request(endpoint, **query)
    xml = @client.perform_request(endpoint, **query)
    convert_to_hash? ? parse_xml(xml) : xml
  end

  def validate_required_one_of!(**values)
    return if values.any? { |_, value| value.present? }

    raise ArgumentError, "You must provide at least one of: #{values.keys.join(', ')}"
  end

  def parse_xml(xml)
    Hash.from_xml(xml).deep_symbolize_keys
  end

  alias convert_to_hash? convert_to_hash
end
