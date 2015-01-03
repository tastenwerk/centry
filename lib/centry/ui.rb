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
      path = Centry::Plugin.find_view( filename )
      return "#{filename} not found" unless path
      ERB.new(File.read(path)).result(nil)
    end

  end
end
