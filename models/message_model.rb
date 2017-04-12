require 'json'
require 'base64'
require 'sequel'

# Holds a Message's Information
class Message_model < Sequel::Model
	one_to_one : key
	plugin : association_dependencies, key: :delete


	def to_json(options = {})
    JSON({ id: @id,
           from: @from,
            },
         options)
  end


end