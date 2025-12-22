# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "bgg_remote"

require_relative "support/bgg_stub_helper"

require "minitest/autorun"
require "webmock/minitest"
