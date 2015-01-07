module Centry

  module API

    class Organizations < Grape::API

      include Centry::API::Container
      centry_mountpoint :api
      
      version 'v1', using: :path

      namespace 'organizations' do

        helpers Centry::ApplicationHelper
        helpers Centry::AuthHelper

        #
        # GET /
        #
        desc "lists all organizations for current_user"
        get do
          authenticate!
          present current_user.oganizations, with: Entities::Organization
        end

        #
        # GET /:id
        #
        desc "returns the organization for given id"
        get ':id' do
          authenticate!
          error("InsufficientRights",403) unless current_user.organizations.find( params.id )
          org = Organization.find params.id
          present org, with: Entities::Organization
        end

      end

    end

  end

end
