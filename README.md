# Autoshell

Simple wrapper for shell commands, used by [Autotune](https://github.com/voxmedia/autotune).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'autoshell', :github => 'ryanmark/autoshell-ruby'
```

And then execute:

    $ bundle

## Usage

Create a new autoshell object with optional path and environment hash.

```ruby
env = { 'FOO' => 'bar' }
sh = Autoshell.new('~/code/autoshell', env: env)
sh.clone('https://github.com/ryanmark/autoshell-ruby.git')
sh.setup_environment
sh.cd |s| { s.run('bundle', 'exec', 'rake', 'test') }
```

## Development

After checking out the repo, run `./setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `./console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ryanmark/autoshell. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

