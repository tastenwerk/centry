require 'action_mailer'
require 'premailer-rails'

module Centry

  module Mailer

    def self.register_view_path( path )
      ActionMailer::Base.view_paths << path
    end

  end

end

Premailer::Rails.register_interceptors
Premailer::Rails.config.merge!(preserve_styles: true, remove_ids: true, verbose: true)
