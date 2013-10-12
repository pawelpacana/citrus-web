require 'spec_helper'

describe Citrus::Web::Injector do

  let(:injector)      { described_class.new(configuration, build_queue) }
  let(:configuration) { Citrus::Web::Configuration.new('/tmp/citrus') }
  let(:build_queue)   { fake(:queue) }

  context 'it should be able to create injected objects instances' do
    specify { expect{injector.test_runner}.to_not          raise_error }
    specify { expect{injector.code_fetcher}.to_not         raise_error }
    specify { expect{injector.workspace_builder}.to_not    raise_error }
    specify { expect{injector.configuration_loader}.to_not raise_error }
    specify { expect{injector.execute_build}.to_not        raise_error }
    specify { expect{injector.build_executor}.to_not       raise_error }
    specify { expect{injector.resource_creator}.to_not     raise_error }
    specify { expect{injector.github_adapter}.to_not       raise_error }
    specify { expect{injector.create_build}.to_not         raise_error }
    specify { expect{injector.builds_repository}.to_not    raise_error }
    specify { expect{injector.pubsub_publisher}.to_not     raise_error }
    specify { expect{injector.pubsub_subscriber}.to_not    raise_error }
    specify { expect{injector.publish_events}.to_not       raise_error }
    specify { expect{injector.subscribe_events}.to_not     raise_error }
    specify { expect{injector.event_presenter}.to_not      raise_error }
    specify { expect{injector.clock}.to_not                raise_error }
  end

  it 'should wire event_subscriber to execute_build instances' do
    event_subscriber = fake(:event_subscriber)
    execute_build    = fake(:execute_build) { Citrus::Core::ExecuteBuild }

    stub(Citrus::Core::ExecuteBuild).new(any_args) { execute_build }
    stub(injector).event_subscriber                { event_subscriber }

    injector.execute_build.inspect
    expect(execute_build).to have_received.add_subscriber(event_subscriber)
  end

end