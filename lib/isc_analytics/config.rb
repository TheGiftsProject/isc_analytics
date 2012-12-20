module IscAnalytics
  class Config

    attr_accessor :accounts, :namespace

    def self.default
      new.instance_eval {
        @accounts = nil
        @namespace = nil

        self
      }
    end
  end
end