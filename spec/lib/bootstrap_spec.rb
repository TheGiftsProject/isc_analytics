require 'spec_helper'
require 'isc_analytics/bootstrap'
require 'isc_analytics'

describe IscAnalytics do

  let(:kissmetrics_config) {
    {
      "key" => 'kissmetrics',
      "dryrun" => false
    }
  }

  let(:google_analytics_config) {
    {
      "key" => 'google'
    }
  }

  let(:optimizely_config) {
    {
      "key" => 'optimizely'
    }
  }

  let(:ipinfodb_config) {
    {
      "key" => 'ipinfodb'
    }
  }

  let(:providers) {
    OpenStruct.new({
      :kissmetrics => kissmetrics_config,
      :google_analytics => google_analytics_config,
      :optimizely => optimizely_config,
      :ipinfodb => ipinfodb_config
    })
  }

  before do
    IscAnalytics.config.providers = providers
  end


  describe :validate_config do
    it 'should raise NoConfigSpecified if no providers set' do
      expect do
        IscAnalytics.config.providers = nil
        IscAnalytics::Bootstrap.new
      end.to raise_error(IscAnalytics::NoConfigSpecified)
    end

    it 'should raise MissingConfigParams if no kissmetrics.key set' do
      expect do
        IscAnalytics.config.providers = OpenStruct.new(:google_analytics => google_analytics_config)
        IscAnalytics::Bootstrap.new
      end.to raise_error(IscAnalytics::MissingConfigParams)
    end

    it 'should raise MissingConfigParams if no google_analytics.key set' do
      expect do
        IscAnalytics.config.providers = OpenStruct.new(:kissmetrics => kissmetrics_config)
        IscAnalytics::Bootstrap.new
      end.to raise_error(IscAnalytics::MissingConfigParams)
    end
  end


  subject { IscAnalytics::Bootstrap.new }

  context :default do
    it { should_not be_opt_out }
    its(:isc_analytics_asset) { should eq 'isc_analytics'}


    describe :analytics_scripts do
      def analytics_scripts
        subject.send(:analytics_scripts)
      end

      it 'should include services' do
        IscAnalytics::Services.should_receive(:scripts).and_return([])
        analytics_scripts
      end
      it 'should include queue' do
        subject.should_receive :queued_events
        analytics_scripts
      end
      it 'should include the regular isc_analytics_asset' do
        analytics_scripts.should include '<script type=\'text/javascript\' src=\'/assets/isc_analytics.js\'></script>'
      end
    end
  end

  context :when_opted_out do
    before { subject.opt_out! }

    it { should be_opt_out }
    its(:isc_analytics_asset) { should eq 'isc_analytics/opt_out_analytics'}

    describe :analytics_scripts do
      def analytics_scripts
        subject.send(:analytics_scripts)
      end

      it 'should not include services' do
        IscAnalytics::Services.should_not_receive(:scripts)
        analytics_scripts
      end
      it 'should include the opt out isc_analytics_asset' do
        analytics_scripts.should include '<script type=\'text/javascript\' src=\'/assets/isc_analytics/opt_out_analytics.js\'></script>'
      end
    end

    describe :queued_events do
      it 'should be empty' do
        subject.queued_events.should == nil
      end
    end
  end

end
