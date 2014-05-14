# Expedition

Expedition is a gem for interacting with cgminer and cgminer-compatible APIs.
The goal of this project is to offer Rubyists easier integration with the
[cgminer API](https://github.com/ckolivas/cgminer/blob/master/API-README) “the
Ruby way.”

**tl;dr** This gem lets you interact with cgminer’s API the way a Ruby hipster
would want to.

Now for some fancy badges:

[![Gem Version](https://badge.fury.io/rb/expedition.png)](http://badge.fury.io/rb/expedition)
[![Dependency Status](https://gemnasium.com/gevans/expedition.png)](https://gemnasium.com/gevans/expedition)
[![Build Status](https://travis-ci.org/gevans/expedition.png?branch=master)](https://travis-ci.org/gevans/expedition)
[![Code Climate](https://codeclimate.com/github/gevans/expedition.png)](https://codeclimate.com/github/gevans/expedition)
[![Coverage Status](https://coveralls.io/repos/gevans/expedition/badge.png?branch=master)](https://coveralls.io/r/gevans/expedition?branch=master)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'expedition'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install expedition

## Usage

A client can be initialized with an optional host and port (defaulting to
`localhost`, port `4028`):

```ruby
client = Expedition.new(host, port)
```

Querying is done by calling the method you wish to send:

```ruby
response = client.pools
# => #<Expedition::Response ...>

response.body
# => [{"pool"=>0,
#  "url"=>"stratum+tcp://pool.example.com:3333",
#  "status"=>"alive"
#  ...}]

response.status
# => #<Expedition::Status
#  @code=7
#  @description="sgminer 4.1.153",
#  @executed_at=2014-05-13 17:51:53 -0700,
#  @message="1 Pool(s)",
#  @severity=:success>>

response.ok?
# => true
```

## Supported API Methods

Expedition overrides `#method_missing` to allow sending *any* method to a
running miner. For convenience and additional sugar, the following methods are
implemented which offer parsed timestamps, and more consistent responses:

* `#devices` - Detailed information about devices.
* `#metrics` - Detailed statistics for all devices.
* `#pools` - Pool information and statistics.

In need of another method?
[Open an issue](https://github.com/gevans/expedition/issues/new).

## Contributing

1. Fork it (http://github.com/gevans/expedition/fork)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
