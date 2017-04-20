require 'json'
require 'base64'
require 'sequel'

require_relative '../lib/secure_db'

# Holds a Message's Information
class Message < Sequel::Model
	plugin :uuid, field: :id

	#set_allowed_columns :title, :about

	# encrypt field data functions
	def from=( from_plain )
		self.from_secure = SecureDB.encrypt(from_plain)
	end

	def to=( to_plain )
		self.to_secure = SecureDB.encrypt(to_plain)
	end

	def title=( title_plain )
		self.to_secure = SecureDB.encrypt(title_plain)
	end

	def about=(about_plain)
		self.to_secure = SecureDB.encrypt(about_plain)
	end

	def status=(status_plain)
		self.to_secure = SecureDB.encrypt(status_plain)
	end

	# decrypt field data functions
	def from
		SecureDB.decrypt(from_secure)
	end

	def to
		SecureDB.decrypt(to_secure)
	end

	def title
		SecureDB.decrypt(title_secure)
	end

	def about
		SecureDB.decrypt(about_secure)
	end

	def status
		SecureDB.decryt(status_secure)
	end

# Json string

	def to_json(options = {})
    JSON({
						type: 'message',
				 		id: id,
           	attributes: {
							from: from,
	            to: to,
	            title: title,
	            about: about,
	            expire_date: expire_date,
	            status: status,
	            body_secure: body_secure
						}
         },
         options)
  	end
end
