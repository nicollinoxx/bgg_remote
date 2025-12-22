# frozen_string_literal: true

require "test_helper"

class TestBggRemote < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::BggRemote::VERSION
  end

  def test_should_configure_api
    BggRemote.configure do |config|
      config.token = "test-token"
    end

    assert_instance_of BggRemote::Api, BggRemote.api
  end
end
