require 'crack/xml'

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

  def plays(username: nil, id: nil, **params)
    validate_at_least_one_of!(username: username, id: id)

    request("plays", username: username, id: id, **params)
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

  def validate_at_least_one_of!(**values)
    return if values.any? { |_, value| !!value }

    raise ArgumentError, "You must provide at least one of: #{values.keys.join(', ')}"
  end

  def parse_xml(xml)
    Crack::XML.parse(xml)
  end

  def convert_to_hash?
    convert_to_hash != false
  end
end
