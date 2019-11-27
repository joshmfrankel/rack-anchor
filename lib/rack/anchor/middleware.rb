module Rack
  module Anchor
    # This is the entry point for the gem to wrap a rack application around
    # the provided validators
    class Middleware
      def initialize(app)
        @app = app
        @validator = Validator
      end

      def call(env)
        if @validator.new(request: Rack::Request.new(env)).valid?
          @app.call(env)
        else
          invalidate_request!
        end
      end

      private

      def invalidate_request!
        [400, {}, ['Bad Request']]
      end
    end
  end
end
