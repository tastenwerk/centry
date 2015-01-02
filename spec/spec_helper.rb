ENV['RACK_ENV'] = 'test'
ENV['CENTRY_ROOT'] = File::dirname(__FILE__)+'/support'
require 'simplecov'
require 'hashie'
SimpleCov.start

require 'bundler/setup'
require 'rack/test'
Bundler.setup

require 'centry'
require 'request_store'
require 'database_cleaner'

require 'factory_girl'
Dir.glob("#{File::expand_path '../factories', __FILE__}/*.rb").each do |file|
  require file
end

module RspecHelper
  module CentryHelper

    def app
      Rack::Builder.new do
        use RequestStore::Middleware
        run Centry::API::Root
      end
    end

    def json
      Hashie::Mash.new( JSON.parse last_response.body )
    end

  end
end

RSpec.configure do |config|

  config.mock_with :rspec
  config.color = true
  config.tty = true
  config.fail_fast = true
  config.formatter = :documentation # :progress, :html, :textmate
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.include RspecHelper::CentryHelper
  config.include Rack::Test::Methods
  config.include FactoryGirl::Syntax::Methods

  config.before(:suite) do
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.clean_with(:truncation)
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end

end
