require 'sequel'

Sequel.seed(:development) do
	def run
		puts 'Seeding accounts, public_key, messages'
		create_accounts
		create_public_key
		create_messages
	end
end

require 'yaml'
DIR = File.dirname(__FILE__)
ALL_ACCOUNTS_INFO = YAML.load_file("#{DIR}/accounts_seed.yml")
ALL_PUBLIC_KEY_INFO = YAML.load_file("#{DIR}/public_key_seed.yml")
ALL_MESSAGES_INFO = YAML.load_file("#{DIR}/message_seed.yml")

def create_accounts
	ALL_ACCOUNTS_INFO.each do |account_info|
    CreateAccount.call(account_info)
end

def create_public_key
	ALL_PUBLIC_KEY_INFO.each{ |public_key_info| CreatePublicKeyForAccount.call(public_key_info) }
end

def create_messages
	ALL_MESSAGES_INFO.each{ |messages_info| SendMessage.call(messages_info) }
end