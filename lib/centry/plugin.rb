module Centry

  class Plugin

    @@paths = []

    def self.load_all
      @@paths.each do |dir|
        Dir.glob( "#{dir}/{helpers,entities,api,models,mailer}/**/*.rb" ).each do |file|
          require file
        end
        self.require_api_root( dir )
        self.register_mailer_paths( dir )
        self.register_assets_paths( dir ) if Centry.respond_to?(:assets)
      end
    end

    def self.find_view( viewname )
      @@paths.each do |dir|
        Dir.glob( "#{dir}/{views}/**/*.erb" ).each do |file|
          return file if File::basename(file) == viewname
        end
      end
      nil
    end

    def self.find_static_file( filename )
      @@paths.each do |dir|
        Dir.glob( "#{dir}/../public/**/*" ).each do |file|
          return file if file.split('public').last == filename
        end
      end
      nil
    end

    def self.register_path( path )
      raise "invalid path #{path}" unless File::exists?(path)
      @@paths << Pathname.new(path).realpath.to_s
    end

    def self.paths
      @@paths
    end

    private

    def self.require_api_root( dir )
      api_root = File::join( dir, 'api.rb' )
      return unless File::exists? api_root
      require api_root
    end

    def self.register_mailer_paths( dir )
      mailer_path = File::join( dir, 'views' )
      return unless File::exists? mailer_path
      Centry::Mailer.register_view_path( mailer_path )
    end

    def self.register_assets_paths( dir )
      assets_path = File::join( dir, 'assets' )
      Centry.assets << File::join( assets_path, '/javascripts' )
      Centry.assets << File::join( assets_path, '/stylesheets' )
      Centry.assets << File::join( assets_path, '/images' )
    end

  end

end
