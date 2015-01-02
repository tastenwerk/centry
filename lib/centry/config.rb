require 'hashie'
require 'yaml'

module Centry

  @@config = nil

  def self.config
    return @@config if @@config
    @@config = {} 
    @@config[:mailer] = YAML.load(Centry.Root.join('config','mailer.yml'))
    @@config = Hashie::Mash.new @@config
  end

end