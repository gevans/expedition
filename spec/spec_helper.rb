require 'simplecov'
require 'coveralls'

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
  SimpleCov::Formatter::HTMLFormatter,
  Coveralls::SimpleCov::Formatter
]
SimpleCov.start do
  add_filter '/.bundle/'
  add_filter '/spec/'
end

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'expedition'

RSpec.configure do |config|
  config.expect_with(:rspec) { |c| c.syntax = :expect }
  config.filter_run focus: true unless ENV['CI']
  config.order = 'random'
  config.run_all_when_everything_filtered = true
  config.treat_symbols_as_metadata_keys_with_true_values = true

  config.before(:suite) do
    @time_zone = ENV['TZ']
    ENV['TZ']  = 'UTC'
  end

  config.after(:suite) do
    ENV['TZ'] = @time_zone
  end
end

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }
