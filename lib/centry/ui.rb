require 'erb'
require 'centry/assets'

module Centry

  class Response
    def initialize(body, code = 200, headers = {})
      @code = code
      @headers = {"Content-Type" => "text/html"}.merge(headers)
      @body = [body]
    end
    def call(env)
      [@code, @headers, @body]
    end
  end

  module View

    def self.render( filename )
      ERB.new(File.read(filename)).result(nil)
    end

    class FileStreamer

      def initialize(path)
        @file = File.open(path)
      end

      def each(&blk)
        @file.each(&blk)
      ensure
        @file.close
      end

    end

  end

  module UI
    def self.application
      Proc.new do |env|
        path = Rack::Utils.unescape(env['PATH_INFO'])
        path = 'index' if path == '/'
        if file = Centry::Plugin.find_view( path+'.html.erb' )
          Centry::Response.new( Centry::View.render(file)).call(env)
        elsif file = Centry::Plugin.find_static_file( path )
          [ "200", {"Content-Type"=> MIME::Types.type_for(file).first.to_s }, View::FileStreamer.new(file) ]
        else
          Centry::Response.new( "#{path} not found", 404 ).call(env)
        end
      end
    end
  end
end
