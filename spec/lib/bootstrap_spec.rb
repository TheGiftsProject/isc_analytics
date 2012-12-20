require 'spec_helper'
require 'isc_analytics/bootstrap'
require 'isc_analytics'

describe IscAnalytics do

  let(:accounts) {
    OpenStruct.new(
        :kissmetrics_key => 'kissmetrics',
        :google_analytics_key => 'google',
    )
  }

  before do
    IscAnalytics.config.accounts = accounts
  end


  describe :validate_config do
    it 'should raise NoConfigSpecified if no accounts set' do
      expect do
        IscAnalytics.config.accounts = nil
        IscAnalytics::Bootstrap.new
      end.to raise_error(IscAnalytics::NoConfigSpecified)
    end

    it 'should raise MissingConfigParams if no kissmetrics_key set' do
      expect do
        IscAnalytics.config.accounts = OpenStruct.new(:google_analytics_key => 'google')
        IscAnalytics::Bootstrap.new
      end.to raise_error(IscAnalytics::MissingConfigParams)
    end

    it 'should raise MissingConfigParams if no google_analytics_key set' do
      expect do
        IscAnalytics.config.accounts = OpenStruct.new(:kissmetrics_key => 'kiss')
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
      it 'should not include queue' do
        subject.should_not_receive :queued_events
        analytics_scripts
      end
      it 'should include the opt out isc_analytics_asset' do
        analytics_scripts.should include '<script type=\'text/javascript\' src=\'/assets/isc_analytics/opt_out_analytics.js\'></script>'
      end
    end
  end

  its(:analytics_scripts) { should_not be_nil }

end