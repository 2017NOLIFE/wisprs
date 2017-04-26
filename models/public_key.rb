require 'json'
require 'base64'
require 'sequel'

require_relative '../lib/secure_db'

# Holds a Public key's Information
class Public_key < Sequel::Model
  plugin :uuid, field: :id
  many_to_one :owner, class: :Account

  plugin :timestamps, update_on_create: true
	plugin :association_dependencies, owner: :destroy

  # set_allowed_columns :name, :key

  # encrypt field data functions
  def name=(name_plain)
    self.name_secure = SecureDB.encrypt(name_plain)
  end

  def key=(key_plain)
    self.key_secure = SecureDB.encrypt(key_plain)
  end

  def owner=(owner_plain)
    self.owner_secure = SecureDB.encrypt(owner_plain)
  end

  # decrypt field data functions
  def name
    SecureDB.decrypt(name_secure)
  end

  def key
    SecureDB.decrypt(key_secure)
  end

  def owner
    SecureDB.decrypt(owner_secure)
  end

  def to_json(options = {})
    JSON({
            type:  'public_key',
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
