require 'isc_analytics/server_apis/kissmetrics'

describe IscAnalytics::ServerApis::Kissmetrics do
  subject { IscAnalytics::ServerApis::Kissmetrics.new("key") }
  let(:identity) { "identity" }

  before do
    KM.stub(:init)
  end

  describe "initialize" do
    it "raises an ArgumentError if no key is passed" do
      expect {
        IscAnalytics::ServerApis::Kissmetrics.new(nil)
      }.to raise_error ArgumentError
    end
  end

  shared_examples_for :api_call do |method, km_api|
    it "calls identify before #{method}" do
      KM.should_receive(:identify).with(identity).ordered
      KM.should_receive(km_api).ordered
      subject.send(method, identity, nil)
    end
  end

  describe "track_event" do
    it_behaves_like :api_call, :track_event, :record
  end

  describe "set_properties" do
    it_behaves_like :api_call, :set_properties, :set
  end

  describe "alias" do
    it_behaves_like :api_call, :alias, :alias
  end
end
