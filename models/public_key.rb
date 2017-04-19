require 'json'
require 'base64'
require 'sequel'

# Holds a Public key's Information
class Public_key < Sequel::Model
	plugin :uuid, field: :id

	#set_allowed_columns :name, :key

	# encrypt field data functions
	def name = (name_plain)
		self.to_secure = secureDB.encrypt(name_plain)
	end

	def key = (key_plain)
		self.to_secure = secureDB.encrypt(key_plain)
	end

	def owner = (owner_plain)
		self.to_secure = secureDB.encrypt(owner_plain)
	end

	# decrypt field data functions
	def name
		secureDB.decrypt(name_secure)
	end

	def key
		secureDB.decrypt(key_secure)
	end

	def owner
		secureDB.decrypt(owner_secure)
	end


	def to_json(options = {})
    JSON({
						type: 'public_key',
				 		id: id,
           	attributes: {
							name: name,
	            key: key,
							owner: owner
						}
         },
         options)
  	end
end
