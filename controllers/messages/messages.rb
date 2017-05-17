require 'sinatra'

# /api/v1/messages routes
class WispersBase < Sinatra::Base
  def authorized_affiliated_message(env, project_id)
    account = authenticated_account(env)
    #all_projects = FindAllAccountProjects.call(id: account['id'])
    #all_projects.select { |proj| proj.id == project_id.to_i }.first
    nil
  rescue => e
    logger.error "ERROR finding project: #{e.inspect}"
    nil
  end

  get '/api/v1/messages/?' do
    content_type 'application/json'

    JSON.pretty_generate(data: Message.all)
  end

  get '/api/v1/messages/:id' do
    content_type 'application/json'

    message_id = params[:id]

    message = Message.where(id: message_id).first #authorized_affiliated_message(env, message_id)

    if message
      message.to_json
    else
      error_msg = "FAILED TO GET MESSAGE: \"#{message_id}\""
      logger.info error_msg
      halt 401, error_msg
    end
  end
end
