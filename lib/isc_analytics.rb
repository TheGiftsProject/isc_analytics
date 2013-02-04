require "#{File.dirname(__FILE__)}/isc_analytics/engine"
require "#{File.dirname(__FILE__)}/isc_analytics/config"
require "#{File.dirname(__FILE__)}/isc_analytics/client_api"
require "#{File.dirname(__FILE__)}/isc_analytics/exceptions"
require "#{File.dirname(__FILE__)}/isc_analytics/bootstrap"
require "#{File.dirname(__FILE__)}/isc_analytics/controller_support"
require "#{File.dirname(__FILE__)}/isc_analytics/server"

module IscAnalytics

  mattr_accessor :app

  def self.config
    @configuration ||= IscAnalytics::Config.default
  end

  def self.server
    @server ||= IscAnalytics::Server.new(config.providers)
  end

end

