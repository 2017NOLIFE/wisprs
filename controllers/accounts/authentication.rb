require 'sinatra'
require 'econfig'
# /api/v1/accounts authentication related routes
class WispersBase < Sinatra::Base
  post '/api/v1/accounts/authenticate' do
    content_type 'application/json'
    begin
      credentials = JsonRequestBody.parse_symbolize(request.body.read)
      authenticated = AuthenticateAccount.call(credentials)
    rescue => e
      halt 500
      logger.info "Cannot authenticate: #{e}"
    end
    authenticated ? authenticated.to_json : halt(403)
  end

  get '/api/v1/github_account' do
    content_type 'application/json'
    #begin
      sso_account, auth_token =
        AuthenticateSsoAccount.new(settings.config).call(params['code'])
      { account: sso_account, auth_token: auth_token }.to_json
    #rescue => e
    #  logger.error "FAILED to validate Github account: #{e.inspect}"
    #  halt 400
    #end
  end

  get '/api/v1/github_sso_url' do
    content_type 'application/json'
    gh_url = 'https://github.com/login/oauth/authorize'
    client_id = settings.config.GH_CLIENT_ID
    scope = 'user:email'
    { url: "#{gh_url}?client_id=#{client_id}&scope=#{scope}" }.to_json
  end
end
