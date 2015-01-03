require 'hashie'
require 'yaml'

module Centry

  def self.configure( &block )
    config = { 
      action_mailer: ActionMailer::Base,
      i18n: I18n
    }
    yield Hashie::Mash.new(config) if block_given?
  end

end

application_config_file = Centry::Root.join 'config', 'application.rb'

if File::exists? application_config_file
  require application_config_file
end
