require 'json'
require 'base64'
require 'sequel'

require_relative '../lib/secure_db.rb'

# Holds a Message's Information
class Message < Sequel::Model
	plugin :uuid, field: :id

	#set_allowed_columns :title, :about

	# encrypt field data functions
	def from = ( from_plain )
		self.from_secure = secureDB.encrypt(from_plain)
	end

	def to = ( to_plain )
		self.to_secure = secureDB.encrypt(to_plain)
	end

	def title = ( title_plain )
		self.to_secure = secureDB.encrypt(title_plain)
	end

	def about = (about_plain)
		self.to_secure = secureDB.encrypt(about_plain)
	end

	def status = (status_plain)
		self.to_secure = secureDB.encrypt(status_plain)
	end

	# decrypt field data functions
	def from
		secureDB.decrypt(from_secure)
	end

	def to
		secureDB.decrypt(to_secure)
	end

	def title
		secureDB.decrypt(title_secure)
	end

	def about
		secureDB.decrypt(about_secure)
	end

	def status
		secureDB.decryt(status_secure)
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
