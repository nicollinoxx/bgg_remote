# frozen_string_literal: true

require "test_helper"

class TestBggRemote < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::BggRemote::VERSION
  end

  def test_it_does_something_useful
    assert false
  end
end
