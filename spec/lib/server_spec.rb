require 'isc_analytics/server'

describe IscAnalytics::Server do

  let(:key) { "key" }
  let(:dryrun) { true }

  let(:providers_config) {
    OpenStruct.new({
      :kissmetrics => {
        "key" => key,
        "dryrun" => dryrun
      }
    })
  }

  let!(:providers) {
    [
      double(:provider1, { :track_event => nil, :set_properties => nil, :alias => nil }),
      double(:provider2, { :track_event => nil, :set_properties => nil, :alias => nil })
    ]
  }

  subject { IscAnalytics::Server.new(providers_config) }

  shared_examples_for :api_call do |method|
    before do
      subject.instance_variable_set(:@providers, providers)
    end

    it "dispatches the call to all apis" do
      providers.each { |provider| provider.should_receive(method) }
      subject.send(method, "identity", nil)
    end
  end

  describe "track_event" do
    it_behaves_like :api_call, :track_event
  end

  describe "set_properties" do
    it_behaves_like :api_call, :set_properties
  end

  describe "alias" do
    it_behaves_like :api_call, :alias
  end
end
