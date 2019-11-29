require 'spec_helper'

RSpec.describe 'Request made with Validator middleware' do
  it 'has a version number' do
    expect(Rack::Anchor::VERSION).not_to be nil
  end

  it 'builds a fake app' do
    get '/'

    expect(last_response.ok?).to be true
    expect(last_response.body).to eq 'fake endpoint'
  end

  context 'when request contains malicious characters' do
    context 'for invalid Cookies' do
      it 'responds with 400 Bad Request' do
        set_cookie 'my_session=abcde%00'

        get '/'

        expect(last_response.bad_request?).to eq true
        expect(last_response.body).to eq 'Bad Request'
      end
    end

    context 'for invalid params' do
      it 'responds with 400 Bad Request' do
        ascii8bit = "\xBF"

        get '/', name: [
          {
            inner_key: "I am #{ascii8bit} bad"
          }
        ]

        expect(last_response.bad_request?).to eq true
        expect(last_response.body).to eq 'Bad Request'
      end
    end
  end

  context 'when request contains valid characters' do
    context 'for a valid request' do
      it 'responds with a 200' do
        set_cookie 'my_session=abcdefg'

        get '/', name: 'Mr. Safety Pants'

        expect(last_response.ok?).to be true
      end
    end
  end
end
