module Rack
  module Anchor
    # This class determines if a part of the incoming request contains
    # a specified invalid character or improper encoding. The end goal
    # is to return a Boolean result via the #valid? message.
    class Validator
      INVALID_CHARACTERS = [
        "\x00"
      ].freeze
      MAX_RECURSION_DEPTH = 2 # TODO: should make this a config setting

      def initialize(request:)
        @request = request
      end

      def valid?
        return false if any_invalid_cookies?
        return false if any_invalid_params?
        true
      end

      private

      def any_invalid_cookies?
        @request.cookies.values.any? do |value|
          string_contains_invalid_character?(value)
        end
      end

      def any_invalid_params?
        @request.params.values.any? do |value|
          check_for_invalid_characters_recursively(value)
        end
      end

      def check_for_invalid_characters_recursively(value, depth = 0)
        return false if depth > MAX_RECURSION_DEPTH

        depth += 1
        if value.respond_to?(:match)
          string_contains_invalid_character?(value)
        elsif value.respond_to?(:values)
          value.values.any? do |hash_value|
            check_for_invalid_characters_recursively(hash_value, depth)
          end
        elsif value.is_a?(Array)
          value.any? do |array_value|
            check_for_invalid_characters_recursively(array_value, depth)
          end
        end
      end

      def string_contains_invalid_character?(string)
        invalid_characters_regex = Regexp.union(INVALID_CHARACTERS)

        string
          .encode('UTF-8', 'binary')
          .match?(invalid_characters_regex)
      rescue Encoding::UndefinedConversionError
        true
      end
    end
  end
end
