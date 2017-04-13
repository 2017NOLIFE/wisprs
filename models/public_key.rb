require 'json'
require 'base64'
require 'sequel'

# Holds a Public key's Information
class Public_key < Sequel::Model


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
