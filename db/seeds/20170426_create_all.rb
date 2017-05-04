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
end

def create_public_key
	public_key = ALL_PUBLIC_KEY_INFO.each
  	loop do
    	public_key_item = public_key.next
			account = Account.first(username: public_key_item[:owner_username])
    	CreatePublicKeyForAccount.call(owner_id: account.id, key: public_key_item[:key], name: public_key_item[:name])
  	end

end

def create_messages
	messages = ALL_MESSAGES_INFO.each
  	loop do
			#from_id:, to_id:, title:, about:, expire_date:, status:, body:
    	messages_item = messages.next
			sender = Account.first(username: messages_item[:from_username])
			receiver = Account.first(username: messages_item[:to_username])

    	SendMessage.call(from_id: sender.id, to_id: receiver.id,
   			title: messages_item[:title], about: messages_item[:about],
				expire_date: messages_item[:expire_date],
				status: messages_item[:status], body: messages_item[:body])
  	end
end
