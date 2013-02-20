require 'km'

module IscAnalytics
  module ServerApis
    class Kissmetrics
      def initialize(key, dryrun=false)
        raise ArgumentError.new("IscAnalytics::ServerApis::Kissmetrics requires a key") if key.blank?
        KM.init(key, { :dryrun => dryrun })
      end

      def track_event(identity, event_name, properties={})
        identify(identity)
        KM.record(event_name, properties)
      end

      def set_properties(identity, properties)
        identify(identity)
        KM.set(properties)
      end

      def alias(original_identity, alias_identity)
        identify(original_identity)
        KM.alias(original_identity, alias_identity)
      end

      private
      def identify(identity)
        raise ArgumentError.new("identity must be provided") if identity.blank?
        KM.identify(identity)
      end
    end
  end
end
