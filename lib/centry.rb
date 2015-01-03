require 'securerandom'
require 'mongoid'
require 'grape'
require 'grape-entity'
require 'rack/builder'
require 'rack/cors'
require 'request_store'
require 'logger'

require "centry/version"
require "centry/root"
require "centry/plugin"
require "centry/userstamps"
require "centry/timestamps"
require "centry/mongoid"
require "centry/mailer"
require "centry/config"

module Centry

  #
  # return centry env
  # defaults to RACK_ENV
  #
  def self.env
    (ENV['RACK_ENV'] || 'development').to_sym
  end

  def self.application
    Rack::Builder.new do
      use RequestStore::Middleware
      use Rack::Cors do
        allow do
          origins '*'
          resource '*', headers: :any, methods: [:get, :post, :options]
        end
      end
      run Centry::API::Root
    end
  end

  def self.logger
    @@logger || Logger.new(STDOUT)
  end

end

Centry::Plugin.register_path File::dirname( __FILE__ )+'/../app'
Centry::Plugin.load_all

Centry::Mongoid.init
