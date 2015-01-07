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
require "centry/mailer"
require "centry/i18n"
require "centry/config"
require "centry/api"

module Centry

  @@logger = Logger.new(STDOUT)

  #
  # return centry env
  # defaults to RACK_ENV
  #
  def self.env
    (ENV['RACK_ENV'] || 'development').to_sym
  end

  def self.logger
    @@logger
  end

end

Centry::Config.load_application_config
Centry::Plugin.register_path File::dirname( __FILE__ )+'/../app'
Centry::Plugin.load_all

Centry::Mongoid.init
