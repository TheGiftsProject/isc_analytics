module IscAnalytics
  class Engine < ::Rails::Engine
    initializer 'isc_analytics.assets' do |app|
      IscAnalytics.app = app
      app.config.assets.precompile += %w(isc_analytics.js isc_analytics/session.js isc_analytics/opt_out_analytics.js)
    end
  end
end