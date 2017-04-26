require 'json'
require 'base64'
require 'sequel'

require_relative '../lib/secure_db'

# Holds an Account's Information
class Account < Sequel::Model
<<<<<<< HEAD
	plugin :uuid, field: :id
	one_to_one :public_key
	one_to_many :sent_messages, class: :Message, key: :from
	one_to_many :received_messages, class: :Message, key: :to

	plugin :timestamps, update_on_create: true
	plugin :association_dependencies, public_key: :destroy
	plugin :association_dependencies, sent_messages: :destroy
	plugin :association_dependencies, received_messages: :destroy
=======
  plugin :uuid, field: :id
>>>>>>> 02f147faa49fe6d3a4a9d7809460abfae8b7651d

  # set_allowed_columns :user_name

<<<<<<< HEAD
	# encrypt field data functions
	def username=(username_plain)
		self.username_secure = SecureDB.encrypt(username_plain)
	end
=======
  # encrypt field data functions
  def user_name=(user_name_plain)
    self.user_name_secure = SecureDB.encrypt(user_name_plain)
  end
>>>>>>> 02f147faa49fe6d3a4a9d7809460abfae8b7651d

  def email=(email_plain)
    self.email_secure = SecureDB.encrypt(email_plain)
  end

<<<<<<< HEAD
	def password_hash=(password_hash_plain)
		self.password_hash_secure = SecureDB.encrypt(password_hash_plain)
	end
=======
  def password_hash=(password_hash_plain)
    self.password_hash_secure = SecureDB.encrypt(password_hash_plain)
  end
>>>>>>> 02f147faa49fe6d3a4a9d7809460abfae8b7651d

  def salt=(salt_plain)
    self.salt_secure = SecureDB.encrypt(salt_plain)
  end

<<<<<<< HEAD
	# decrypt field data functions
	def username
		SecureDB.decrypt(username_secure)
	end
=======
  # decrypt field data functions
  def user_name
    SecureDB.decrypt(user_name_secure)
  end
>>>>>>> 02f147faa49fe6d3a4a9d7809460abfae8b7651d

  def email
    SecureDB.decrypt(email_secure)
  end

  def password_hash
    SecureDB.decrypt(password_hash_secure)
  end

  def salt
    SecureDB.decrypt(salt_secure)
  end

  # Json string

  def to_json(options = {})
    JSON({
<<<<<<< HEAD
						type: 'account',
            id: id,
           	attributes: {
              username: username,
              email: email,
              password_hash: password_hash,
              salt: salt
						}
         },
         options)
	end

	# Password set and gets
	def check_pass(text_to_check)
		salt = self.salt # probably wrong
		SecureDB.password_hash(text_to_check, salt) == self.password_hash
	end

	def set_pass(new_pass)
		salt = SecureDB.new_salt
		SecureDB.password_hash(new_pass, salt)
	end

=======
            type: 'account', id: id,
            attributes: {
              user_name: user_name, email: email,
              password_hash: password_hash, salt: salt
            }
         },
         options)
  end

  # Password set and gets
  def check_pass(text_to_check)
    salt = self.salt # probably wrong
    SecureDB.password_hash(text_to_check, salt) == self.password_hash
  end

  def set_pass(new_pass)
    salt = SecureDB.new_salt
    SecureDB.password_hash(new_pass, salt)
  end
>>>>>>> 02f147faa49fe6d3a4a9d7809460abfae8b7651d
end
