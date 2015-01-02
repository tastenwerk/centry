require 'action_mailer'

module Centry

  module Mailer

    def self.init
      # ActionMailer::Base.raise_delivery_errors = true
      ActionMailer::Base.delivery_method = :test
      # ActionMailer::Base.smtp_settings = {
      #    :address   => "smtp.gmail.com",
      #    :port      => 587,
      #    :domain    => "domain.com.ar",
      #    :authentication => :plain,
      #    :user_name      => "test@domain.com.ar",
      #    :password       => "passw0rd",
      #    :enable_starttls_auto => true
      #   }
    end

    def self.register_view_path( path )
      ActionMailer::Base.view_paths << path
    end

  end

end