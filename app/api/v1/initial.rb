module Centry::API
  
  class Initial < Grape::API
  
    include Centry::API::Container
    centry_mountpoint :api
      
    prefix '/v1/initial'

    #
    # POST /init
    #
    desc "initial setup (allows you to create your first user account and organization)"
    params do
      requires :organization_name
      requires :email
      requires :username
      requires :password
    end
    post :init do
      return error!('SetupIsCompletedAlready',403) if Centry::User.count > 0
      org = Centry::Organization.create( name: params.organization_name )
      Centry::User.create( organization_id: org.id, username: params.username, password: params.password, email: params.email )
    end

  end
end
