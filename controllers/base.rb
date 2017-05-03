require 'econfig'
require 'sinatra'
require 'rack/ssl-enforcer'

# Secure chat based api
class WispersBase < Sinatra::Base
  extend Econfig::Shortcut

  configure do
    Econfig.env = settings.environment.to_s
    Econfig.root = File.expand_path('..', settings.root)

    SecureDB.setup(settings.config)
  end

  configure :production do
    use Rack::SslEnforcer
  end

  before do
    host_url = "#{request.env['rack.url_scheme']}://#{request.env['HTTP_HOST']}"
    @request_url = URI.join(host_url, request.path.to_s)
  end

  get '/?' do
    'Secure chat web API up at /api/v1'
  end
end
