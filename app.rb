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
end
