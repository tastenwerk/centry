require "centry/userstamps"
require "centry/timestamps"

module Centry

  module Mongoid

    def self.init
      mongoid_yml = Centry::Root.join 'config', 'mongoid.yml'
      if Centry.env == :test
        mongoid_yml = File::dirname(__FILE__)+'/../../spec/support/config/mongoid.yml'
      end

      ::Mongoid.load!(mongoid_yml, Centry.env)
    end

  end

end

module BSON
  class ObjectId
    alias :to_json :to_s
    alias :as_json :to_s
  end
end