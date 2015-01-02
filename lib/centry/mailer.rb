require 'action_mailer'

module Centry

  module Mailer

    def self.register_view_path( path )
      ActionMailer::Base.view_paths << path
    end

  end

end