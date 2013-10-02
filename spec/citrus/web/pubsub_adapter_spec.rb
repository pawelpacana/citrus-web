require 'spec_helper'

describe Citrus::Web::NanoPubsubAdapter::Publisher do

  let(:address)    { 'inproc://' << SecureRandom.hex }
  let(:publisher)  { described_class.new(address) }
  let(:subscriber) { NanoMsg::SubSocket.new.tap { |s| s.connect(address) } }

  specify { expect(publisher).to respond_to(:publish) }

  it 'should publish data to subscribers' do
    subscriber.subscribe('subject')

    publisher.publish('subject', 'message')
    expect(subscriber.recv).to eq('subject message')
  end
end

describe Citrus::Web::NanoPubsubAdapter::Subscriber do

  ENOUGH_TIME_TO_SUBSCRIBE_BEFORE_PUBLISHING = 0.1
  ENOUGH_TIME_TO_EXPECT_NO_PUBLICATION = 2 * ENOUGH_TIME_TO_SUBSCRIBE_BEFORE_PUBLISHING

  let(:address)    { 'inproc://' << SecureRandom.hex }
  let(:subscriber) { described_class.new(address) }
  let(:publisher)  { NanoMsg::PubSocket.new.tap { |s| s.bind(address) } }

  specify { expect(subscriber).to respond_to(:subscribe) }
  before  { subscriber } # eager loading socket

  it 'should receive published data' do
    received_data = nil
    Thread.new do
      sleep(ENOUGH_TIME_TO_SUBSCRIBE_BEFORE_PUBLISHING)
      publisher.send('subject message')
    end

    subscriber.subscribe('subject') { |msg| received_data = msg; break }
    expect(received_data).to eq('message')
  end

  it 'should receive messages only for subscribed subject' do
    received_data = nil
    Thread.new do
      sleep(ENOUGH_TIME_TO_SUBSCRIBE_BEFORE_PUBLISHING)
      publisher.send('subject message')
    end

    begin
      Timeout.timeout(ENOUGH_TIME_TO_EXPECT_NO_PUBLICATION) do
        subscriber.subscribe('other_subject') { |msg| received_data = msg; break }
      end
    rescue Timeout::Error
    end
    expect(received_data).to eq(nil)
  end

  it 'should not receive messages published before subscribing' do
    received_data = nil
    publisher.send('subject message')

    begin
      Timeout.timeout(ENOUGH_TIME_TO_EXPECT_NO_PUBLICATION) do
        subscriber.subscribe('other_subject') { |msg| received_data = msg; break }
      end
    rescue Timeout::Error
    end
    expect(received_data).to eq(nil)
  end

end
