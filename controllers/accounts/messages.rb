require 'sinatra'

# /api/v1/projects routes only
class WispersBase < Sinatra::Base
  # Get all projects for an account
  get '/api/v1/accounts/:id/messages/?' do
    content_type 'application/json'

    begin
      requesting_account = authenticated_account(env)
      target_account = BaseAccount[params[:id]]

      viewable_messages =
        MessagePolicy::Scope.new(requesting_account, target_account)
                            .viewable
      JSON.pretty_generate(data: viewable_messages)
    rescue
      error_msg = "FAILED to find Messages for user: #{params[:id]}"
      logger.info error_msg
      halt 404, error_msg
    end
  end
  # Send a new project
  post '/api/v1/accounts/:id/send_message/?' do
    begin
      new_message_data = JSON.parse(request.body.read)
      saved_message = SendMessage.call(
        from_id: params[:id],
        to_id: new_message_data['to_id'],
        title: new_message_data['title'],
        about: new_message_data['about'],
        expire_date: new_message_data['expire_date'],
        status: new_message_data['status'],
        body: new_message_data['body']
      )
      new_location = URI.join(@request_url.to_s + '/',
                              saved_message.id.to_s).to_s
    rescue => e
      logger.info "FAILED to send the new message: #{e.inspect}"
      halt 400
    end

    status 201
    headers('Location' => new_location)
  end
end
