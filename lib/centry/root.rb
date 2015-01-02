module Centry

  def self.root
    ENV['CENTRY_ROOT'] || Dir.pwd
  end

  module Root

    def self.join( *opts )
      File::join( Centry.root, opts )
    end

  end

end
