module Centry
  module API

    class Root < Grape::API

      include Centry::API::Container
      
      mount API::Users
      mount API::Organizations
      mount API::Auth
      mount API::Initial

    end

  end
end
