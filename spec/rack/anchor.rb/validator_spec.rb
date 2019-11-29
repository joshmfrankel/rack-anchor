require 'spec_helper'

RSpec.describe Rack::Anchor::Validator do
  describe '#valid?' do
    let(:null_byte) { "\x00" }
    let(:ascii8bit) { "\xBF" }
    let(:env) { Rack::MockRequest.env_for('/protected') }

    context 'when checking Cookies' do
      it 'returns false if a Cookie contains a null byte character' do
        env['HTTP_COOKIE'] = 'VALID_COOKIE=123;LOGIN_SESSION=abcde%00'
        request = Rack::Request.new(env)
        validator = described_class.new(request: request)

        expect(validator.valid?).to be false
      end

      it 'returns false if a Cookie contains an ASCII-8BIT character' do
        env['HTTP_COOKIE'] = 'VALID_COOKIE=123;LOGIN_SESSION=abcde%BF'
        request = Rack::Request.new(env)
        validator = described_class.new(request: request)

        expect(validator.valid?).to be false
      end

      it 'returns true if all Cookies contain valid characters' do
        env['HTTP_COOKIE'] = 'VALID_COOKIE=123;LOGIN_SESSION=abcde'
        request = Rack::Request.new(env)
        validator = described_class.new(request: request)

        expect(validator.valid?).to be true
      end
    end

    context 'when checking params' do
      let(:request) { Rack::Request.new(env) }

      context 'for top level strings' do
        it 'returns false when param contains a null byte character' do
          request.params['name'] = "I am #{null_byte} bad"
          validator = described_class.new(request: request)

          expect(validator.valid?).to be false
        end

        it 'returns false when param contains invalid encoding' do
          request.params['name'] = "I am #{ascii8bit} bad"
          validator = described_class.new(request: request)

          expect(validator.valid?).to be false
        end

        it 'returns true when param is valid' do
          request.params['name'] = 'I am safe'
          validator = described_class.new(request: request)

          expect(validator.valid?).to be true
        end
      end

      context 'for hashes with strings' do
        it 'returns false when param contains a null byte character' do
          request.params['name'] = { inner_key: "I am #{null_byte} bad" }
          validator = described_class.new(request: request)

          expect(validator.valid?).to be false
        end

        it 'returns false when param contains invalid encoding' do
          request.params['name'] = { inner_key: "I am #{ascii8bit} bad" }
          validator = described_class.new(request: request)

          expect(validator.valid?).to be false
        end

        it 'returns true when param is valid' do
          request.params['name'] = { inner_key: 'I am safe' }
          validator = described_class.new(request: request)

          expect(validator.valid?).to be true
        end
      end

      context 'for arrays with strings' do
        it 'returns false when param contains a null byte character' do
          request.params['name'] = ["I am #{null_byte} bad"]
          validator = described_class.new(request: request)

          expect(validator.valid?).to be false
        end

        it 'returns false when param contains invalid encoding' do
          request.params['name'] = ["I am #{ascii8bit} bad"]
          validator = described_class.new(request: request)

          expect(validator.valid?).to be false
        end

        it 'returns true when param is valid' do
          request.params['name'] = ['I am safe']
          validator = described_class.new(request: request)

          expect(validator.valid?).to be true
        end
      end

      context 'for arrays containing hashes with string values' do
        it 'returns false when param contains a null byte character' do
          request.params['name'] = [{ inner_key: "I am #{null_byte} bad" }]
          validator = described_class.new(request: request)

          expect(validator.valid?).to be false
        end

        it 'returns false when param contains invalid encoding' do
          request.params['name'] = [{ inner_key: "I am #{ascii8bit} bad" }]
          validator = described_class.new(request: request)

          expect(validator.valid?).to be false
        end

        it 'returns true when param is valid' do
          request.params['name'] = [{ inner_key: 'I am safe' }]
          validator = described_class.new(request: request)

          expect(validator.valid?).to be true
        end
      end

      # @see Rack::Anchor::Validator::MAX_RECURSION_DEPTH for threshold
      it "doesn't exceed the max recursive depth even for invalid characters" do
        request.params['name'] = [{ inner_key: ["I am #{null_byte} bad"] }]
        validator = described_class.new(request: request)

        expect(validator.valid?).to be true
      end
    end
  end
end
