# frozen_string_literal: true
require "test_helper"

class TestBggRemoteApi < Minitest::Test
  include BggStubHelper

  def setup
    set_bgg_api
  end

  def test_should_fetch_thing_data_from_api
    stub_bgg("thing", query: { id: 200 }, fixture: "thing")

    result = @api.thing(id: 200)
    item   = result.dig(:items, :item)

    assert_requested :get, /xmlapi2\/thing/, times: 1
    assert_equal "200", item[:id]
    assert_equal "Time Warp", item[:name].first[:value]
  end

  def test_should_fetch_family_data_from_api
    stub_bgg("family", query: { id: 500, type: "boardgamefamily" }, fixture: "family")

    result = @api.family(id: 500, type: "boardgamefamily")
    item   = result.dig(:items, :item)

    assert_requested :get, /xmlapi2\/family/, times: 1
    assert_equal "boardgamefamily", item[:type]
    assert_equal "500", item[:id]
    assert_equal "This is the family of Galaxy Quest Games.", item[:description]
  end

  def test_should_fetch_forum_list_data_from_api
    stub_bgg("forumlist", query: { id: 174430, type: "thing" }, fixture: "forum_list")

    result = @api.forum_list(id: 174430, type: "thing")
    forums = result[:forums]

    assert_requested :get, /xmlapi2\/forumlist/, times: 1
    assert_equal [174430, "thing"], [forums[:id].to_i, forums[:type]]
    assert_equal 10, forums[:forum].size
    assert_equal "Reviews", forums[:forum].first[:title]
  end

  def test_should_fetch_forum_data_from_api
    stub_bgg("forum", query: { id: 100, page: 1 }, fixture: "forum")

    result = @api.forum(id: 100, page: 1)
    forum  = result[:forum]

    assert_requested :get, /xmlapi2\/forum/, times: 1
    assert_equal "100", forum[:id]
    assert_equal 2, forum[:threads][:thread].size
    assert_equal "Boardgame Discussions", forum[:title]
  end

  def test_should_fetch_threads_data_from_api
    stub_bgg("thread", query: { id: 101 }, fixture: "thread")

    result = @api.thread(id: 101)
    thread = result[:thread]

    assert_requested :get, /xmlapi2\/thread/, times: 1
    assert_equal "101", thread[:id]
    assert_equal "mockuser", thread.dig(:articles, :article, :username)
  end

  def test_should_fetch_user_data_from_api
    stub_bgg("user", query: { name: "mockuser1" }, fixture: "user")

    result = @api.user(name: "mockuser1")
    user = result[:user]

    assert_requested :get, /xmlapi2\/user/, times: 1
    assert_equal "5001", user[:id]
    assert_equal "mockuser1", user[:name]
  end

  def test_should_fetch_guild_data_from_api
    stub_bgg("guild", query: { id: 1229, members: 1 }, fixture: "guild")

    result = @api.guild(id: 1229, members: 1)
    guild = result[:guild]

    assert_requested :get, /xmlapi2\/guild/, times: 1
    assert_equal "5000", guild[:id]
    assert_equal "Mock Guild", guild[:name]
    assert_equal 25, guild[:members][:member].size
  end

  def test_should_fetch_plays_data_from_api
    stub_bgg("plays", query: { id: 101, type: "thing", mindate: "2025-01-01", maxdate: "2025-01-01" }, fixture: "plays")

    result = @api.plays(id: 101, type: "thing", mindate: "2025-01-01", maxdate: "2025-01-01")
    plays = result[:plays]

    assert_requested :get, /xmlapi2\/plays/, times: 1
    assert_equal "3", plays[:total]
    assert_equal 3, plays[:play].size
    assert_equal "MockGame 1", plays[:play].first.dig(:item, :name)
  end

  def test_should_search_data_from_api
    stub_bgg("search", query: { query: "MockGame Alpha" }, fixture: "search")

    result = @api.search(query: "MockGame Alpha")
    items = result[:items]

    assert_requested :get, /xmlapi2\/search/, times: 1
    assert_equal "3", items[:total]
    assert_equal 3, items[:item].size
    assert_equal "MockGame Alpha", items[:item].first.dig(:name, :value)
  end

  def test_should_fetch_collection_from_api
    stub_bgg("collection", query: { username: "mockuser1", own: 1, brief: 1, subtype: "boardgame" }, fixture: "collection")

    result = @api.collection(username: "mockuser1", own: 1, brief: 1, subtype: "boardgame")
    items = result[:items]

    assert_requested :get, /xmlapi2\/collection/, times: 1
    assert_equal "3", items[:totalitems]
    assert_equal 3, items[:item].size
    assert_equal "Lords of Mock", items[:item].first[:name]
  end

  def test_should_fetch_data_and_do_not_parse_response
    stub_bgg("thing", query: { id: 200 }, fixture: "thing")

    @api.convert_to_hash = false
    result = @api.thing(id: 200)

    assert_requested :get, /xmlapi2\/thing/, times: 1
    assert_includes result, "<items"
    assert_includes result, "<item"
  end

  private

  def set_bgg_api
    client = BggRemote::Client.new("fake-token")
    @api = BggRemote::Api.new(client)
  end
end
