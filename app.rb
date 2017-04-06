require 'sinatra'
require 'json'
require 'base64'
require_relative 'models/Message'

# secure chat based api
class WispersBase < Sinatra::Base
  configure do
    enable :logging
    Message.setup
  end

  get '/?' do
    'ConfigShare web API up at /api/v1'
  end

  get '/api/v1/Messages/?' do
    content_type 'application/json'
    output = { Message_id: Message.all }
    JSON.pretty_generate(output)
  end

  get '/api/v1/Messages/:id/document' do
    content_type 'text/plain'

    begin
      Base64.strict_decode64 Message.find(params[:id]).document
    rescue => e
      status 404
      e.inspect
    end
  end

  get '/api/v1/Messages/:id.json' do
    content_type 'application/json'

    begin
      output = { Message: Message.find(params[:id]) }
      JSON.pretty_generate(output)
    rescue => e
      logger.info "FAILED to GET Message: #{e.inspect}"
      status 404
    end
  end

  post '/api/v1/Messages/?' do
    content_type 'application/json'

    begin
      new_data = JSON.parse(request.body.read)
      new_config = Message.new(new_data)
      if new_config.save
        logger.info "NEW Message STORED: #{new_config.id}"
      else
        halt 400, "Could not store config: #{new_config}"
      end

      redirect '/api/v1/Messages/' + new_config.id + '.json'
    rescue => e
      logger.info "FAILED to create new config: #{e.inspect}"
      status 400
    end
  end
end
