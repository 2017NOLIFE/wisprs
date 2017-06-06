require 'sinatra'

# /api/v1/public_keys routes
class WispersBase < Sinatra::Base
  get '/api/v1/accounts/:id/public_keys/?' do
    content_type 'application/json'
    account_id = params[:id]
    account = BaseAccount.where(id: account_id).first
    public_key = account.public_key
    if public_key
      JSON.pretty_generate(data: public_key)
    else
      error_msg = "FAILED TO GET PUBLIC KEY FOR ACCOUNT: \"#{account_id}\""
      logger.info error_msg
      halt 404, error_msg
    end
  end
end
