module Centry
  module API

    class Root < Grape::API

      default_format :json
      format :json

      mount API::Users
      mount API::Auth
      mount API::Initial

    end

  end
end
