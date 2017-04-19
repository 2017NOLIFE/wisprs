require 'sinatra'

# /api/v1/public_keys routes
class WispersBase < Sinatra::Base
  get '/api/v1/public_keys/?' do
    content_type 'application/json'

    JSON.pretty_generate(data: Public_key.all)
  end

  get '/api/v1/public_keys/:id' do
    content_type 'application/json'

    public_key_id = params[:id]
    public_key = Public_key[public_key_id]

    if public_key
      JSON.pretty_generate(data: public_key)
    else
      error_msg = "FAILED TO GET PUBLIC KEY: \"#{public_key_id}\""
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