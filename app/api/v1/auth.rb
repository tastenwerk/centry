module Centry

  module API

    class Auth < Grape::API

      helpers Centry::AuthHelper

      prefix '/v1/auth'

       # ============================================================
      # POST
      desc "authenticates a user"
      params do
        requires :login, desc: "email address or username accepted"
        requires :password, desc: "the user's password"
      end
      post do
        authenticate_user
        @current_user.api_key
      end

    end

  end

end