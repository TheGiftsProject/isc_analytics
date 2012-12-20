require "#{File.dirname(__FILE__)}/isc_analytics/engine"
require "#{File.dirname(__FILE__)}/isc_analytics/config"
require "#{File.dirname(__FILE__)}/isc_analytics/client_api"
require "#{File.dirname(__FILE__)}/isc_analytics/exceptions"
require "#{File.dirname(__FILE__)}/isc_analytics/controller_support"

module IscAnalytics

  mattr_accessor :app

  def self.config
    @configuration ||= IscAnalytics::Config.default
  end

end

