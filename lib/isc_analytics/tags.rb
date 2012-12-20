require 'active_support/core_ext/string/output_safety'

module IscAnalytics
  module Tags

    def self.scripts(scripts_array)
      scripts_array.compact.join().html_safe
    end

    def self.script_tag(script)
      "<script type='text/javascript'>#{script}</script>"
    end

    def self.script_link_tag(link)
      "<script type='text/javascript' src='#{link}'></script>"
    end
  end
end