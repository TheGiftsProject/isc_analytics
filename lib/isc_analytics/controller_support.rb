require 'controller_support/base'

module IscAnalytics
  ## A mixin that provides access to isc_analytics API in the controller.
  module ControllerSupport
    extend ::ControllerSupport::Base

    helper_method :add_analytics, :analytics, :opt_out!, :opt_out?

    ##Is the analytics tracking disabled for the current page?
    def opt_opt?
      analytics.opt_out?
    end

    ##This method will disable the analytics tracking of the user
    def opt_out!
      analytics.opt_out!
    end

    ##This method will generate all the javascript needed for client-side analytics tracking.
    ##This also includes server-side analytics events that were queued to the client during the current request.
    def add_analytics
      analytics.analytics_script_tags
    end

    def analytics
      isc_analytics
    end

    def keep_km_url_event
      analytics.keep_km_url_event(params)
    end

    private

    def isc_analytics
      @isc_analytics_bootstrap ||= IscAnalytics::Bootstrap.new(:session => session)
    end
  end
end
