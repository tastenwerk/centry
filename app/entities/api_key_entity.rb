module Centry

  module API

    module Entities

      class ApiKey < Grape::Entity
        expose :id
        expose :name
        expose :token
        expose :expires_at
        expose :permanent
        expose :user_id
      end

    end

  end

end