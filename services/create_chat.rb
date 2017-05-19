# frozen_string_literal: true

# Service object to create new chat using all columns

class CreateChat
  def self.call(sender_id:, receiver_id:)
    chat = Chat.new()
    chat.sender = Account[sender_id]
    chat.receiver = Account[receiver_id]
    chat.save
  end
end
