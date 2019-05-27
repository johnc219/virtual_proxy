[![Gem Version](https://badge.fury.io/rb/virtual_proxy.svg)](https://badge.fury.io/rb/virtual_proxy)

# VirtualProxy

- Quickly build virtual proxies.
- Messages sent to these proxies are forwarded to custom lazily-evaluated subjects.
- Based on the GoF [proxy pattern](https://en.wikipedia.org/wiki/Proxy_pattern).
- Uses Ruby's [Delegator library](http://ruby-doc.org/stdlib-2.6/libdoc/delegate/rdoc/Delegator.html) to avoid [`method_missing` gotchas](https://github.com/rubocop-hq/ruby-style-guide#no-method-missing).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'virtual_proxy'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install virtual_proxy

## Usage

```ruby
# Create a proxy to some subject
proxy = VirtualProxy.to { ExpensiveObject.new } # => VirtualProxy::Proxy
proxy.expensive_object_method

# Get the subject directly
proxy.__getobj__ # => ExpensiveObject instance

# Dynamically set a new subject
proxy.__setobj__ { OtherExpensiveObject.new }
proxy.other_expensive_object_method

# Extend any class or object with proxy construction capabilities
class ExpensiveObject
  extend VirtualProxy

  attr_reader :name
  def initialize(name:)
    @name = name
  end
end

proxy = ExpensiveObject.build_lazy(name: 'fubar')
proxy.foo # => 'fubar'

# Use it for any expensive code
proxy = VirtualProxy.to { perform_intensive_task }
proxy.generate_report

# Avoid method_missing gotchas
proxy = VirtualProxy.to { [1, 2, 3] }
proxy == [1, 2, 3] # => true
proxy.methods # => [..., :push, :append, :pop, :shift, ...]
proxy.respond_to?(:sort) # => true
# NOTE: introspective methods such as :respond_to? require the subject to be evaluated
```

## Performance

Note that the Ruby Delegator class uses `method_missing` under the hood.

[This](./bin/benchmark) benchmark suggests that the `Delegator` approach taken in this gem, when compared against a simpler but more limited approach, incurs a %1.28 performance penalty:
```
                   user     system      total        real
virtual_proxy  6.834716   0.000324   6.835040 (  6.849857)
simple_proxy   6.754349   0.000008   6.754357 (  6.763423)
```
To run this benchmark,
```bash
chmod +x ./bin/benchmark
./bin/benchmark
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/johnc219/virtual_proxy.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
