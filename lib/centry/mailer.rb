require 'action_mailer'
require 'roadie'

module Centry

  module Mailer

    @@asset_provider_paths = []

    def self.register_view_path( path )
      ActionMailer::Base.view_paths << path
    end

    def self.register_mailer_assets_path( path )
      @@asset_provider_paths << Roadie::FilesystemProvider.new(path)
    end

    def self.transform( email )
      doc = Roadie::Document.new( email.body.decoded )
      doc.asset_providers = @@asset_provider_paths
      email.body.raw_source.replace doc.transform
      email
    end

  end

end
