require 'spec_helper'

module IscAnalytics
  describe KISSMetricsClientAPI do

    subject { ClientApiContainer.new }

    def enqueue(name, *args)
      subject.send(:enqueue, name, args)
    end

    def queue
      subject.send(:queue)
    end

    describe :api do
      it { should respond_to :identify }
      it { should respond_to :clear_identify }
      it { should respond_to :track_event }
      it { should respond_to :set_properties }
      it { should respond_to :set_property }
      it { should respond_to :generate_queue_js }
    end

    describe :enqueue do
      it 'should add to a new queue if first' do
        enqueue('test')
        queue.should have(1).item
      end

      it 'should append to queue' do
        enqueue('foo')
        enqueue('test')
        queue.should have(2).item
      end

      it 'should not add duplicates' do
        enqueue('test')
        enqueue('test')
        queue.should have(1).item
      end

      it 'should support args and properties' do
        enqueue('action', 'name', :key => :value)
        queue.should have(1).item
      end
    end

    describe :generate_queue_js do
      it 'should reset the queue' do
        enqueue('test')
        subject.generate_queue_js
        queue.should be_empty
      end

      it 'should generate the correct JS' do
        enqueue('test', 'name')
        subject.generate_queue_js.should eq "Analytics.test([\"name\"]);"
      end

      it 'should generate empty string for no queue' do
        subject.generate_queue_js.should be_empty
      end
    end

    describe :actions do
      describe :track_event do
        it 'should enqueue just the name if given just event name' do
          subject.track_event('event')
          queue.should include 'trackEvent("event");'
        end

        it 'should enqueue w/properties if given ' do
          subject.track_event('event', :key => 'value')
          queue.should include 'trackEvent("event",{"key":"value"});'
        end

        it 'should not enqueue if event_name is empty' do
          subject.track_event(nil)
          queue.should be_empty
        end
      end

      describe :set_property do
        it 'should support key-value' do
          subject.set_property('key','value')
          queue.should include 'setProperty("key","value");'
        end
        it 'should add default value of nil' do
          subject.set_property('key')
          queue.should include 'setProperty("key",null);'
        end
        it 'should not enqueue if no property given' do
          subject.set_property(nil)
          queue.should be_empty
        end
      end

      describe :set_properties do
        it 'should set multiple properties hash' do
          subject.set_properties(:a => 1, :b => 2)
          queue.should include 'setProperties({"a":1,"b":2});'
        end
        it 'should not enqueue if no properties given' do
          subject.set_properties(nil)
          queue.should be_empty
        end
      end
    end

  end
end