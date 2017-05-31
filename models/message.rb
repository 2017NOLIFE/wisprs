# frozen_string_literal: true

# Model for Message

require 'json'
require 'base64'
require 'sequel'

require_relative '../lib/secure_db'

# Holds a Message's Information
class Message < Sequel::Model
  set_allowed_columns :title_secure, :about_secure

  many_to_one :chat, class: :Chat
  many_to_one :from, class: :BaseAccount
  many_to_one :to, class: :BaseAccount

  plugin :timestamps, update_on_create: true

  # encrypt field data functions

  def title=(title_plain)
    self.title_secure = SecureDB.encrypt(title_plain)
  end

  def about=(about_plain)
    self.about_secure = SecureDB.encrypt(about_plain)
  end

  def status=(status_plain)
    self.status_secure = SecureDB.encrypt(status_plain)
  end

  def body=(body_plain)
    self.body_secure = SecureDB.encrypt(body_plain)
  end

  # decrypt field data functions
  def title
    SecureDB.decrypt(title_secure)
  end

  def about
    SecureDB.decrypt(about_secure)
  end

  def status
    SecureDB.decrypt(status_secure)
  end

  def body
    SecureDB.decrypt(body_secure)
  end

# Json string

  def to_json(options = {})
    JSON({
            type: 'message',
             id: id,
             attributes: {
              title: title,
              about: about,
              expire_date: expire_date,
              status: status,
              body: body
            },
            relationships: {
              from: from,
              to: to
            }
         },
         options)
    end
end
