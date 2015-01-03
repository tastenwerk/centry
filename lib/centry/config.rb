require 'hashie'
require 'yaml'

module Centry

  module Config

    def self.load_application_config

      application_config_file = Centry::Root.join 'config', 'application.rb'

      if File::exists? application_config_file
        require application_config_file
      end

    end

    class Site
      attr_accessor :name
    end

  end

  @@config = { 
    action_mailer: ActionMailer::Base,
    i18n: I18n,
    site: Centry::Config::Site.new
  }

  def self.configure( &block )
    yield Hashie::Mash.new(@@config) if block_given?
  end

  def self.config
    Hashie::Mash.new(@@config)
  end

end
