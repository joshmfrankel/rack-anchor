module Rack
  module Anchor
    class Validator
      INVALID_CHARACTERS = [
        "\u0000" # null bytes
      ].freeze

      def initialize(request: Rack::Request.new)
        @request = request
      end

      def valid?
        return true if @request.cookies.dig('my_session').nil?
        !@request.cookies.dig('my_session').nil? && !string_contains_invalid_character?(@request.cookies['my_session'])
      end

      private

      def string_contains_invalid_character?(string)
        invalid_characters_regex = Regexp.union(INVALID_CHARACTERS)

        string.match?(invalid_characters_regex)
      end
    end
  end
end
