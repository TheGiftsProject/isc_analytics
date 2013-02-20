require "isc_analytics/server_apis/kissmetrics"

module IscAnalytics
  class Server
    def initialize(providers_config)
      @providers = []
      @providers << init_kissmetrics(providers_config.kissmetrics)
    end

    def track_event(identity, name, properties={})
      @providers.each do |provider|
        provider.track_event(identity, name, properties)
      end
    end

    def set_properties(identity, properties)
      @providers.each do |provider|
        provider.set_properties(identity, properties)
      end
    end

    def alias(identity, new_identity)
      @providers.each do |provider|
        provider.alias(identity, new_identity)
      end
    end

    private
    def init_kissmetrics(config)
      IscAnalytics::ServerApis::Kissmetrics.new(config["key"], config["dryrun"])
    end
  end
end
