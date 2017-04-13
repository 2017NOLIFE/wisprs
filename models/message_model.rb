require 'json'
require 'base64'
require 'sequel'

# Holds a Message's Information
class Message_model < Sequel::Model
	 

	def to_json(options = {})
    JSON({ id: id,
           from: from,
           to: to,
           title: title,
           about: about,
           expire_date: expire_date,
           status: status,
           body: body
            },
         options)
  	end

end