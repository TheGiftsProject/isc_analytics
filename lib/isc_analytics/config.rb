module IscAnalytics
  class Config

    attr_accessor :providers, :namespace

    def initialize(providers, namespace, amd=false)
      @providers = providers
      @namespace = namespace
    end

    def self.default
      new(nil, nil)
    end
  end
end
