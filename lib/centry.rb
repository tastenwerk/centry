require "centry/version"
require "centry/root"
require "centry/loader"
require "centry/plugin"

require 'securerandom'
require 'mongoid'
require 'grape'

module Centry

  #
  # return centry env
  # defaults to RACK_ENV
  #
  def self.env
    (ENV['RACK_ENV'] || 'development').to_sym
  end

end

Centry::Plugin.register_path File::dirname( __FILE__ )+'/../app'
Centry::Plugin.load_all

mongoid_yml = Centry::Root.join 'config', 'mongoid.yml'
if Centry.env == :test
  mongoid_yml = File::dirname(__FILE__)+'/../spec/support/config/mongoid.yml'
end

Mongoid.load!(mongoid_yml, Centry.env)