require 'citrus/core'
require 'webmachine'
require 'thread'
require 'dependor'
require 'dependor/shorty'
require 'core_ext'
require 'tnetstring'
require 'm2r_adapter'

module Citrus
  module Web
    class << self

      def root
        Pathname.new(File.expand_path('../../', File.dirname(__FILE__)))
      end

      def log_root
        @log_root ||= root.join('log')
      end

    end
  end
end

require 'citrus/web/injector'
require 'citrus/web/resource'
require 'citrus/web/configuration'
require 'citrus/web/resource_creator'
require 'citrus/web/github_push_resource'
require 'citrus/web/build_console_resource'
require 'citrus/web/build_resource'
require 'citrus/web/build_collection_resource'
require 'citrus/web/event_bus_resource'
require 'citrus/web/application'
require 'citrus/web/threaded_build_executor'
require 'citrus/web/builds_repository'
require 'citrus/web/create_build'
require 'citrus/web/pubsub_adapter'
require 'citrus/web/publish_events'
require 'citrus/web/publish_console'
require 'citrus/web/event'
require 'citrus/web/event_presenter'
require 'citrus/web/build_presenter'
require 'citrus/web/event_subscriber'
require 'citrus/web/build_console_subscriber'
require 'citrus/web/clock'
require 'citrus/web/null_serializer'
require 'citrus/web/subscriptions_repository'
require 'citrus/web/unsubscribe_client'
require 'citrus/web/subscription'
require 'citrus/web/subscribe_client'
require 'citrus/web/streamer'
require 'citrus/web/server_sent_events_encoder'
