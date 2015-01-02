module Centry
  module API
    module Entities

      class User < Grape::Entity
        
        root :users, :user

        expose :id
        expose :username
        expose :email
        expose :firstname
        expose :lastname
        expose :role
        expose :organization_ids
      end

    end
  end
end