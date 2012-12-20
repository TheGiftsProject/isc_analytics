require 'isc_analytics/tags'
require 'isc_analytics/services'

module IscAnalytics
  class Bootstrap
    include KISSMetricsClientAPI

    def initialize(options = {})
      validate_accounts_config
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

    private

    def analytics_scripts
      scripts = []
      scripts.concat Services.scripts(config.accounts) unless opt_out?
      scripts << isc_analytics_tag
      scripts << extend_analytics(config.namespace)
      scripts << queued_events unless opt_out?
      scripts
    end

    def config
      IscAnalytics.config
    end

    def validate_accounts_config
      raise IscAnalytics::NoConfigSpecified.new('You have specified a nil config, you must specify an EnvConfigReader of your Analytics Accounts keys') if config.accounts.nil?

      if config.accounts.kissmetrics_key.nil?
        raise IscAnalytics::MissingConfigParams.new('KISSMetrics configuration key isn\'t specified in your config.')
      elsif config.accounts.google_analytics_key.nil?
        raise IscAnalytics::MissingConfigParams.new('Google Analytics configuration key isn\'t specified in your config.')
      end
    end

    def queued_events
      queue_js = generate_queue_js
      return nil if queue_js.blank?
      Tags.script_tag(queue_js)
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