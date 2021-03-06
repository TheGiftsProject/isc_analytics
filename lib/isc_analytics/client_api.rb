module IscAnalytics
  module KISSMetricsClientAPI

    def identify(identifier, properties = {})
      unless identifier.blank? || is_identified(identifier)
        remove_duplicated_identify
        if properties.blank?
          enqueue 'identify', identifier
        else
          enqueue 'identify', identifier, escape_properties(properties)
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
          enqueue 'trackEvent', CGI::escapeHTML(name)
        else
          enqueue 'trackEvent', CGI::escapeHTML(name), escape_properties(properties)
        end
      end
    end

    def set_properties(properties = {})
      enqueue('setProperties', escape_properties(properties)) unless properties.blank?
    end

    def set_property(property, value = nil)
      enqueue('setProperty', CGI::escapeHTML(property), value ? CGI::escapeHTML(value) : value) unless property.blank?
    end

    # reset_queue makes sure that subsequent calls will not send events that have already been sent.
    def generate_queue_js(reset_queue = true)
      buffer = get_parsed_queue_string
      queue.clear if reset_queue
      buffer
    end

    def keep_km_url_event(params)
      kme = params["kme"]

      if kme
        props = {}
        params.each do |key, value|
          if key.to_s.start_with?("km_")
            prop_name = key[3..-1]
            props[prop_name] = value
          end
        end

        track_event(kme, props)
      end
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

    def escape_properties(properties)
      Hash[properties.map{ |k, v| [(k.kind_of?(String) ? CGI::escapeHTML(k) : k), (v.kind_of?(String) ? CGI::escapeHTML(v) : v)] }]
    end

  end
end
