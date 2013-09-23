module Citrus
  module Web
    class BuildConsoleResource < Resource

      def initialize
        set_headers
      end

      def set_headers
        response.headers['Connection']    ||= 'keep-alive'
        response.headers['Cache-Control'] ||= 'no-cache'
      end

      def allowed_methods
        %w(GET)
      end

      def content_types_provided
        [['text/event-stream', :render_event]]
      end

      def render_event
        build    = Core::Build.new(nil, SecureRandom.uuid, Core::FileOutput.new('dummy.log', Pathname.new('/tmp')))
        streamer = FileStreamer.new(build.output.path.to_s)

        Fiber.new { streamer.stream { |data| Fiber.yield(data) } }
      end

    end
  end
end
