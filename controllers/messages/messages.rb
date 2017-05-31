require 'sinatra'

# /api/v1/messages routes
class WispersBase < Sinatra::Base
  def authorized_affiliated_message(env, message_id)
    account = authenticated_account(env)
    all_messages = FindAllAccountMessages.call(id: account.id)
    all_messages.select { |msg| msg.id == message_id.to_i }.first
  rescue => e
    logger.error "ERROR finding message: #{e.inspect}"
    nil
  end

  get '/api/v1/messages/:id' do
    content_type 'application/json'

    message_id = params[:id]
    message = authorized_affiliated_message(env, message_id)

    if message
      message.to_json
    else
      error_msg = "FAILED TO GET MESSAGE: \"#{message_id}\""
      logger.info error_msg
      halt 401, error_msg
    end
  end
end
