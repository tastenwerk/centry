require 'sprockets'

module Centry

  def self.assets
    @@assets ||= Centry::Assets.new
  end

  class Assets
    
    def initialize
      @assets = Sprockets::Environment.new
    end

    def <<(dir)
      @assets.append_path dir
    end

    def assets
      @assets
    end

  end
end
