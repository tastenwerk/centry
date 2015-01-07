module Centry
  module API

    class Root < Grape::API

      default_format :json
      format :json

      helpers Centry::UsersHelper

      before { set_organization_id }

      mount API::Users
      mount API::Organizations
      mount API::Auth
      mount API::Initial

    end

  end
end
