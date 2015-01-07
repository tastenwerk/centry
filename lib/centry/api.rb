require File::join( File::dirname(__FILE__), '..','..','app','helpers','application_helper' )
require File::join( File::dirname(__FILE__), '..','..','app','helpers','users_helper' )

module Centry

  module API

    @@mount_paths = []

    def self.mount_paths
      @@mount_paths
    end

    def self.add_mount_path(path)
      @@mount_paths << path
    end

    def self.application
      Rack::Builder.new do
        use Centry::UserLocale
        use RequestStore::Middleware
        use Rack::Cors do
          allow do
            origins '*'
            resource '*', headers: :any, methods: [:get, :post, :options]
          end
        end
        Centry::API::mount_paths.each do |path|
          run path
        end
        # run Centry::API::Root
      end
    end

    module Container

      extend ActiveSupport::Concern

      included do
        default_format :json
        format :json
        helpers Centry::UsersHelper
        before { set_organization_id }
      end


      module InstanceMethods

        def centry_mountpoint( path )
          Centry::API.add_mount_path self
        end

      end

      module ClassMethods
        include Centry::API::Container::InstanceMethods
      end

    end
    
  end

end