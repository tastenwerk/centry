require 'sprockets'
require 'sprockets-helpers'
require 'handlebars_assets'
require 'coffee-script'

HandlebarsAssets::Config.ember = true

module Centry

  def self.assets
    @@assets ||= Centry::Assets.new
  end

  class Assets
    
    def initialize
      @assets = Sprockets::Environment.new
      @assets.append_path HandlebarsAssets.path
      Sprockets::Helpers.configure do |config|
        config.environment = @assets
        config.prefix      = '/assets'
        config.digest      = false
        config.debug       = ( Centry.env == :development )
      end
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
