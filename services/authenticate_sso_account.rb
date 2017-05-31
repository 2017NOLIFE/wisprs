# Find or create an SsoAccount based on Github code
require 'http'

class AuthenticateSsoAccount
  def initialize(config)
    @config = config
  end

  def call(code)
    access_token = get_access_token(code)
    github_account = get_github_account(access_token)
    sso_account = find_or_create_sso_account(github_account)
    [sso_account, AuthToken.create(sso_account)]
  end
  private_class_method
  def get_access_token(code)
    HTTP.headers(accept: 'application/json')
        .post('https://github.com/login/oauth/access_token',
              form: { client_id: @config.GH_CLIENT_ID,
                      client_secret: @config.GH_CLIENT_SECRET,
                      code: code })
        .parse['access_token']
  end

  def get_github_account(access_token)
    gh_account = HTTP.headers(user_agent: 'Whispers',
                              authorization: "token #{access_token}",
                              accept: 'application/json')
                     .get('https://api.github.com/user').parse
    { username: gh_account['login'], email: gh_account['email'] }
  end

  def find_or_create_sso_account(github_account)
    SsoAccount.first(github_account) || SsoAccount.create(github_account)
  end
end
