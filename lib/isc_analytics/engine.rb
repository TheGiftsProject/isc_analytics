if defined?(::Rails::Engine)
  module IscAnalytics
    module Rails
      class Engine < ::Rails::Engine
        initializer :assets do |app|
          IscAnalytics.app = app
          app.config.assets.precompile += %w(isc_analytics isc_analytics/session isc_analytics/opt_out_analytics)
        end
      end
    end
  end
end
