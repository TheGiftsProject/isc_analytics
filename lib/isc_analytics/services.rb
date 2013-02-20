require 'isc_analytics/tags'
require 'active_support/core_ext/object/blank'

module IscAnalytics
  class Services

    def self.scripts(providers_config)
      scripts = []
      scripts << kissmetrics_tag(providers_config.kissmetrics["key"]) if providers_config.kissmetrics
      scripts << google_tag(providers_config.google_analytics["key"]) if providers_config.google_analytics
      scripts << optimizely_tag(providers_config.optimizely["key"]) if providers_config.optimizely
      scripts << ipinfodb_tag(providers_config.ipinfodb["key"]) if providers_config.ipinfodb
      scripts
    end

    def self.kissmetrics_tag(key)
      Tags.script_tag <<-SCRIPT
      var _kmq = _kmq || [];
      function _kms(u){
        setTimeout(function(){
          var s = document.createElement('script'); var f = document.getElementsByTagName('script')[0];
          s.type = 'text/javascript'; s.async = true;
          s.src = u; f.parentNode.insertBefore(s, f);
        }, 1);
      }
      _kms('//i.kissmetrics.com/i.js');
      _kms('//doug1izaerwt3.cloudfront.net/#{key}.1.js');
      SCRIPT
    end

    def self.google_tag(key)
      Tags.script_tag <<-SCRIPT
        var _gaq = _gaq || [];
        _gaq.push(['_setAccount', '#{key}']);
        _gaq.push(['_trackPageview']);
        (function() {
          var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
          ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
          var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
        })();
      SCRIPT
    end

    def self.optimizely_tag(key)
      return nil if key.blank?
      <<-HTML
        <script src='//cdn.optimizely.com/js/#{key}.js\'></script>
        <script type="text/javascript">
          window['optimizely'] = optimizely || [];
        </script>
      HTML
    end

    def self.ipinfodb_tag(key)
      return nil if key.blank?
      Tags.script_tag "window.IPINFODB_KEY = '#{key}';"
    end

  end
end
