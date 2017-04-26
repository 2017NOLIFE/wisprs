require 'json'
require 'base64'
require 'sequel'

require_relative '../lib/secure_db'

# Holds a Message's Information
class Account < Sequel::Model
  plugin :uuid, field: :id

  # set_allowed_columns :user_name

  # encrypt field data functions
  def user_name=(user_name_plain)
    self.user_name_secure = SecureDB.encrypt(user_name_plain)
  end

  def email=(email_plain)
    self.email_secure = SecureDB.encrypt(email_plain)
  end

  def password_hash=(password_hash_plain)
    self.password_hash_secure = SecureDB.encrypt(password_hash_plain)
  end

  def salt=(salt_plain)
    self.salt_secure = SecureDB.encrypt(salt_plain)
  end

  # decrypt field data functions
  def user_name
    SecureDB.decrypt(user_name_secure)
  end

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
end
