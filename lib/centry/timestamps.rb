require 'active_support/concern'
module Centry

  module Timestamps
    
    extend ActiveSupport::Concern

    included do

      field :created_at, type: DateTime, default: lambda{ Time.now }
      field :updated_at, type: DateTime, default: lambda{ Time.now }

      before_update :set_updated_at

      protected

      def set_updated_at
        self.updated_at = Time.now
      end

    end
  end
end
