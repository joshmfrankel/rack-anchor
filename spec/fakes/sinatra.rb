require 'sinatra/base'
require 'sinatra/cookies'

class FakeApp < Sinatra::Base
  use Rack::Anchor::Middleware

  get '/' do
    'fake endpoint'
  end
end
