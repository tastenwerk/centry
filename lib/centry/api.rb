module Centry

  module API

    def self.application
      Rack::Builder.new do
        use RequestStore::Middleware
        use Rack::Cors do
          allow do
            origins '*'
            resource '*', headers: :any, methods: [:get, :post, :options]
          end
        end
        run Centry::API::Root
      end
    end

  end
  
end