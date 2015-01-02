module Centry

  module ApplicationHelper
    
    def logger
      Centry.logger
    end

    def base_url
      protocol ||= request.ssl? ? 'https://' : 'http://'
      "#{protocol}#{request.host_with_port}"
    end


  end

end