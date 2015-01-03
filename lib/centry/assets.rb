require 'sprockets'
require 'handlebars_assets'

module Centry

  def self.assets
    @@assets ||= Centry::Assets.new
  end

  class Assets
    
    def initialize
      @assets = Sprockets::Environment.new
      @assets.append_path HandlebarsAssets.path
    end

    def <<(dir)
      return unless File::exists? dir
      @assets.append_path dir
    end

    def assets
      @assets
    end

  end
end
