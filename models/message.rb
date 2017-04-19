require 'json'
require 'base64'
require 'sequel'

# Holds a Message's Information
class Message < Sequel::Model
	plugin :uuid, field: :id

	#set_allowed_columns :title, :about

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
