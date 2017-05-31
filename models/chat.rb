# frozen_string_literal: true

# Migration for Chat table

require 'json'
require 'base64'
require 'sequel'

# Holds an Chat's Information
class Chat < Sequel::Model
  many_to_one :sender, class: :BaseAccount
  many_to_one :receiver, class: :BaseAccount
  one_to_many :messages, class: :Message, key: :chat_id

  #plugin :timestamps, update_on_create: true
  plugin :association_dependencies, messages: :destroy
  #plugin :association_dependencies, sender_chats: :destroy
  #plugin :association_dependencies, receiver_chats: :destroy

end
