# frozen_string_literal: true

# Migration for Chat table

require 'json'
require 'base64'
require 'sequel'

require_relative '../lib/secure_db'
require_relative './base_accounts'

# Holds an Account's Information
class Account < BaseAccount
  def password=(new_password)
    new_salt = SecureDB.new_salt
    hashed = SecureDB.hash_password(new_salt, new_password)
    self.salt = new_salt
    self.password_hash = hashed
  end
  def password?(try_password)
    try_hashed = SecureDB.hash_password(salt, try_password)
    try_hashed == password_hash
  end
end
