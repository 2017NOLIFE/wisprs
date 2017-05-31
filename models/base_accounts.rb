# frozen_string_literal: true

# Model for Base Account table

require 'json'
require 'base64'
require 'sequel'

require_relative '../lib/secure_db'

# Holds an BaseAccount's Information
class BaseAccount < Sequel::Model
  plugin :single_table_inheritance, :type
  set_allowed_columns :username, :email

  one_to_one :public_key, class: :Public_key, key: :owner_id

  one_to_many :sender_chats, class: :Chat, key: :sender_id
  one_to_many :receiver_chats, class: :Chat, key: :receiver_id
  one_to_many :sent_messages, class: :Message, key: :from_id
  one_to_many :received_messages, class: :Message, key: :to_id

  plugin :timestamps, update_on_create: true
  plugin :association_dependencies, public_key: :destroy
  plugin :association_dependencies, sender_chats: :destroy
  plugin :association_dependencies, receiver_chats: :destroy
  plugin :association_dependencies, sent_messages: :destroy
  plugin :association_dependencies, received_messages: :destroy

  def password=(new_password)
    new_salt = SecureDB.new_salt
    hashed = SecureDB.hash_password(new_salt, new_password)
    self.salt = new_salt
    self.password_hash = hashed
  end

# Json string

  def to_json(options = {})
    JSON({  type: type,
            id: id,
            username: username,
            email: email,
            salt: salt
         },
         options)
  end

  def password?(try_password)
    try_hashed = SecureDB.hash_password(salt, try_password)
    try_hashed == password_hash
  end
end
