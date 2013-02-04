require 'isc_analytics/tags'
require 'isc_analytics/services'

module IscAnalytics
  class Bootstrap
    include KISSMetricsClientAPI

    def initialize(options = {})
      validate_providers_config
      @session = options[:session] || {}
      @opt_out = false
    end

    def opt_out?
      !!@opt_out
    end

    def opt_out!
      @opt_out = true
    end

    def analytics_script_tags
      Tags.scripts(analytics_scripts)
    end

    def provider_script_tags
      Tags.scripts(provider_scripts)
    end

    def queued_events
      return nil if opt_out?
      generate_queue_js
    end

    private

    def analytics_scripts
      scripts = []
      scripts.concat provider_scripts
      scripts << isc_analytics_tag
      scripts << extend_analytics(config.namespace)
      scripts << Tags.script_tag(queued_events) unless queued_events.blank?
      scripts.compact
    end

    def provider_scripts
      opt_out? ? [] : Services.scripts(config.providers)
    end

    def config
      IscAnalytics.config
    end

    def validate_providers_config
      if config.providers.nil?
        raise IscAnalytics::NoConfigSpecified.new('You have specified a nil config, you must specify an EnvConfigReader of your Analytics providers keys')
      end

      if config.providers.kissmetrics.nil?
        raise IscAnalytics::MissingConfigParams.new('KISSMetrics configuration isn\'t specified in your config.')
      elsif config.providers.google_analytics.nil?
        raise IscAnalytics::MissingConfigParams.new('Google Analytics configuration isn\'t specified in your config.')
      end
    end

    def extend_analytics(namespace)
      return nil if namespace.nil?
      Tags.script_tag <<-SCRIPT
        (function() {
          _.extend(window.#{namespace}, window.Analytics)
        })();
      SCRIPT
    end

    def isc_analytics_tag
      prefix = ''
      if IscAnalytics.app.config.assets.prefix.present?
        prefix = IscAnalytics.app.config.assets.prefix + '/'
      end
      Tags.script_link_tag(prefix + isc_analytics_asset + '.js')
    end

    def isc_analytics_asset
      if opt_out?
        'isc_analytics/opt_out_analytics'
      else
        'isc_analytics'
      end
    end

  end
end
