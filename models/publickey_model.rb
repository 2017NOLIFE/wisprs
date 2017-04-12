require 'json'
require 'base64'
require 'sequel'

# Holds a Message's Information
class Public_model < Sequel::Model
	

	def to_json(options = {})
    JSON({ id: id,
           
            },
         options)
  	end

end