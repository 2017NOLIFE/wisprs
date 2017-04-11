require 'sinatra'

configure :development do
  ENV['DATABASE_URL'] = 'sqlite://db/dev.db'
end

configure :test do
  ENV['DATABASE_URL'] = 'sqlite://db/test.db'
end

configure :production do
end

configure do
  enable :loggig
  require 'sequel'
  DB = Sequel.connect(ENV['DATABASE_URL'])

  require 'hirb'
  Hirb.enable
end
