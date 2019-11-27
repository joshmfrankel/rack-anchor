require "spec_helper"
require "sinatra/base"
require "sinatra/cookies"

class FakeApp < Sinatra::Base
  use Rack::Anchor::Middleware

  get '/' do
    'fake endpoint'
  end
end

RSpec.describe Rack::Anchor do
  include Rack::Test::Methods

  def app
    app = FakeApp.new
    Rack::Builder.new.run(app)
  end

  it 'has a version number' do
    expect(Rack::Anchor::VERSION).not_to be nil
  end

  it 'builds a fake app' do
    get '/'

    expect(last_response.ok?).to be true
    expect(last_response.body).to eq 'fake endpoint'
  end

  context 'when request contains malicious characters' do
    context 'for Cookies' do
      it 'responds with a 400 Bad Request' do
        set_cookie 'my_session=abcde%00'

        get '/'

        expect(last_response.bad_request?).to eq true
        expect(last_response.body).to eq 'Bad Request'
      end
    end
  end

  context 'when request contains valid characters' do
    context 'for Cookies' do
      it 'responds with a 200' do
        set_cookie 'my_session=abcdefg'

        get '/'

        expect(last_response.ok?).to be true
      end
    end
  end
end
