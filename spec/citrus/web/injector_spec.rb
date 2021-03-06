require 'spec_helper'

describe Citrus::Web::Injector do

  let(:injector)                 { described_class.new(configuration, build_queue, builds_repository, subscriptions_repository, zmq_context) }
  let(:configuration)            { Citrus::Web::Configuration.new('/tmp/citrus') }
  let(:build_queue)              { fake(:queue) }
  let(:builds_repository)        { fake(:builds_repository) }
  let(:subscriptions_repository) { fake(:subscriptions_repository) }
  let(:zmq_context)              { fake(:context, socket: zmq_socket) { ZMQ::Context } }
  let(:zmq_socket)               { fake(:socket)                      { ZMQ::Socket } }

  context 'it should be able to create injected objects instances' do
    specify { expect{injector.test_runner}.to_not                    raise_error }
    specify { expect{injector.code_fetcher}.to_not                   raise_error }
    specify { expect{injector.workspace_builder}.to_not              raise_error }
    specify { expect{injector.configuration_loader}.to_not           raise_error }
    specify { expect{injector.execute_build}.to_not                  raise_error }
    specify { expect{injector.build_executor}.to_not                 raise_error }
    specify { expect{injector.resource_creator}.to_not               raise_error }
    specify { expect{injector.github_adapter}.to_not                 raise_error }
    specify { expect{injector.create_build}.to_not                   raise_error }
    specify { expect{injector.publish_events}.to_not                 raise_error }
    specify { expect{injector.publish_console}.to_not                raise_error }
    specify { expect{injector.event_presenter}.to_not                raise_error }
    specify { expect{injector.clock}.to_not                          raise_error }
    specify { expect{injector.event_subscriber }.to_not              raise_error }
    specify { expect{injector.build_console_subscriber }.to_not      raise_error }
    specify { expect{injector.unsubscribe_client }.to_not            raise_error }
    specify { expect{injector.subscribe_client }.to_not              raise_error }
    specify { expect{injector.streamer }.to_not                      raise_error }
    specify { expect{injector.sse_encoder }.to_not                   raise_error }
    specify { expect{injector.build_console_publisher }.to_not       raise_error }
    specify { expect{injector.event_publisher }.to_not               raise_error }
  end

  it 'should wire event_subscriber to execute_build instances' do
    event_subscriber = fake(:event_subscriber)
    execute_build    = fake(:execute_build) { Citrus::Core::ExecuteBuild }

    stub(Citrus::Core::ExecuteBuild).new(any_args) { execute_build }
    stub(injector).event_subscriber                { event_subscriber }

    injector.execute_build
    expect(execute_build).to have_received.add_subscriber(event_subscriber)
  end

  it 'should wire build_console_subscriber to test_runner instance' do
    build_console_subscriber = fake(:build_console_subscriber)
    test_runner              = fake(:test_runner) { Citrus::Core::TestRunner }

    stub(Citrus::Core::TestRunner).new(any_args) { test_runner }
    stub(injector).build_console_subscriber      { build_console_subscriber }

    injector.test_runner
    expect(test_runner).to have_received.add_subscriber(build_console_subscriber)
  end

end
