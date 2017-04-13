require 'sinatra'
require_relative 'config/environments'
require_relative 'models/init'

# Secure chat based api
class WispersBase < Sinatra::Base
  before do
    host_url = "#{request.env['rack.url_scheme']}://#{request.env['HTTP_HOST']}"
    @request_url = URI.join(host_url, request.path.to_s)
  end

  get '/?' do
    'Secure chat web API up at /api/v1'
  end

  get '/api/v1/messages/?' do
    content_type 'application/json'

    JSON.pretty_generate(data: Message.all)
  end

  get '/api/v1/messages/:id' do
    content_type 'application/json'

    message = Message.where("id = #{params[:id]}").first

    if message
      JSON.pretty_generate(data: message)
    else
      error_msg = "FAILED TO GET MESSAGE: \"#{params[:id]}\""
      logger.info error_msg
      halt 404, error_msg
    end
  end

  post '/api/v1/messages/?' do
    content_type 'application/json'

    begin
      new_message = JSON.parse(request.body.read)
      saved_message = Message.create(new_message)
    rescue => e
      error_msg = "FAILED to create a new message: #{e.inspect}"
      logger.info error_msg
      halt 400, error_msg
    end

    status 201
    headers('Location' => [@request_url.to_s, saved_message.id].join('/'))
  end

  get '/api/v1/public_keys/?' do
    content_type 'application/json'

    JSON.pretty_generate(data: Public_key.all)
  end

  get '/api/v1/public_keys/:id' do
    content_type 'application/json'

    public_key = Public_key.where("id = #{params[:id]}").first

    if public_key
      JSON.pretty_generate(data: public_key)
    else
      error_msg = "FAILED TO GET PUBLIC KEY: \"#{params[:id]}\""
      logger.info error_msg
      halt 404, error_msg
    end
  end

  post '/api/v1/public_keys/?' do
    content_type 'application/json'

    begin
      new_public_key = JSON.parse(request.body.read)
      saved_public_key = Public_key.create(new_public_key)
    rescue => e
      error_msg = "FAILED to create a new public key: #{e.inspect}"
      logger.info error_msg
      halt 400, error_msg
    end

    status 201
    headers('Location' => [@request_url.to_s, saved_public_key.id].join('/'))
  end
end
