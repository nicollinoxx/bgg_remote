# frozen_string_literal: true
require "test_helper"

class TestBggRemoteClient < Minitest::Test
  include BggStubHelper

  def setup
    @client = BggRemote::Client.new("fake-token")
  end

  def test_should_initialize_with_token
    assert_equal "fake-token", @client.token
  end

  def test_should_set_default_timeout
    assert_equal 10, @client.timeout
  end

  def test_should_get_response
    stub_bgg("thing", query: { id: 200 }, fixture: "thing")

    response = @client.perform_request("thing", id: 200)

    assert_includes response, "<items"
    assert_includes response, "<item"
  end
end
