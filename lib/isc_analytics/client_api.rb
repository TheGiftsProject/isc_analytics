module IscAnalytics
  module KISSMetricsClientAPI

    def identify(identifier, properties = {})
      unless identifier.blank? || is_identified(identifier)
        remove_duplicated_identify
        if properties.blank?
          enqueue 'identify', identifier
        else
          enqueue 'identify', identifier, properties
        end
        set_identity(identifier)
      end
    end

    def clear_identify
      set_identity(nil) # removed identity from session
      enqueue 'clearIdentity'
    end

    def track_event(name, properties = {})
      unless name.blank?
        if properties.blank?
          enqueue 'trackEvent', name
        else
          enqueue 'trackEvent', name, properties
        end
      end
    end

    def set_properties(properties = {})
      enqueue('setProperties', properties) unless properties.blank?
    end

    def set_property(property, value = nil)
      enqueue('setProperty', property, value) unless property.blank?
    end

    # reset_queue makes sure that subsequent calls will not send events that have already been sent.
    def generate_queue_js(reset_queue = true)
      buffer = get_parsed_queue_string
      queue.clear if reset_queue
      buffer
    end

    private

    def enqueue(name, *args)
      call = "#{name}(#{args.map(&:as_json).map(&:to_json).join(',')});"
      queue << call unless queue.include?(call)
    end

    def queue
      session[:analytics_queue] ||= []
    end

    def session
      @session
    end

    # Parse the queue by adding the JS class name and newlines to each call
    def get_parsed_queue_string
      queue.map{ |api_call| "Analytics.#{api_call}" }.join("\n")
    end

    def is_identified(identifier)
      session[:analytics_identity] == identifier
    end

    def set_identity(identifier)
      session[:analytics_identity] = identifier
    end

    def remove_duplicated_identify
      queue.delete_if { |api_call| !(/identify/ =~ api_call).nil? }
    end

  end
end