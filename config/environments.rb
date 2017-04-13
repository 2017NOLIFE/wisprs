require 'sinatra'

configure :development do
  ENV['DATABASE_URL'] = 'sqlite3://db/dev.db'
end

configure :test do
  ENV['DATABASE_URL'] = 'sqlite3://db/test.db'
end

configure :production do
	# set DATABASE_URL env var
end

configure do
  enable :loggig
  require 'sequel'
  DB = Sequel.connect(ENV['DATABASE_URL'])

  require 'hirb'
  Hirb.enable
end
