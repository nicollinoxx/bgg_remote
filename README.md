# BggRemote

BggRemote is a Ruby client for the [BoardGameGeek XML API](https://boardgamegeek.com/wiki/page/BGG_XML_API2), providing easy access to board game data. It can optionally parse XML responses into Ruby hashes for easier usage.


## Installation

Add this line to your application's `Gemfile`:

```ruby
gem "bgg_remote", "~> 0.1.0"
```
then execute ```bundle install```
Or install it yourself as a gem ``` gem install bgg_remote ```

## Usage

```ruby
BggRemote.configure do |config|
  config.token = "your-api-token"
  config.timeout = 8             # optional, default is 10
  config.convert_to_hash = true  # optional, set to false if you want raw XML
end

# Alternatively, minimal configuration:
# BggRemote.configure do |config|
#   config.token = "your-api-token"
# end

bgg_api = BggRemote.api
bgg_api.thing(id: 21)      # Fetch a boardgame by ID
bgg_api.user(name: "geek") # Fetch a user by name
```

You can also instantiate the client manually if you prefer:

```ruby
client = BggRemote::Client.new("your_api_token", timeout: 21)
bgg_api = BggRemote::Api.new(client, convert_to_hash: true)
# convert_to_hash and timeout are optional

bgg_api.thing(id: 222)
```

## API Endpoints
- thing(id:, **params)
- family(id:, type: nil)
- forum_list(id:, type: nil)
- forum(id:, page: nil)
- thread(id:, **params)
- user(name:, **params)
- guild(id:, **params)
- search(query:, **params)
- plays(username: nil, id: nil, **params) – validates at least one of username or id
- hot_items(type:)
- collection(username:, **params)

**Notes:**
- `**params` can be used for extra parameters, e.g., `bgg_api.thing(id: 3214, stats: 1)`.
- `stats` is an example of an extra parameter.
- **Sending Multiple Parameters** \
Some endpoints support multiple values ​​for a single parameter, such as `id` or `type`. You can pass:

```ruby
#Multiple values as a comma-separated string:
BggRemote.api.family(id: "20,111815", type: "boardgamefamily,rpg")
```

## Details
- The API client also provides error classes for retry logic if needed.
  See: [error.rb](https://github.com/nicollinoxx/bgg_remote/blob/master/lib/bgg_remote/error.rb)
- This gem uses [HTTParty](https://github.com/jnunemaker/httparty) to make HTTP requests and [Crack](https://github.com/jnunemaker/crack) to parse XML into hashes.  You can choose to receive raw XML instead by setting `convert_to_hash = false`.
- The gem does not process the XML content itself; it only wraps HTTP requests
  and optionally converts XML to Ruby hashes.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/nicollinoxx/bgg_remote. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](https://www.contributor-covenant.org/) code of conduct.

## License

This gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
