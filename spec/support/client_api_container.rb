class ClientApiContainer
  include IscAnalytics::KISSMetricsClientAPI

  attr_reader :session

  def initialize
    @session = {}
  end
end