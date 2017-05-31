# frozen_string_literal: true

# Service object to send a new message

class SendMessage
  def self.call(from_id:, to_id:, title:, about:, expire_date:, status:, body:)
    message = Message.new()

    from = BaseAccount[from_id]
    to = BaseAccount[to_id]
    chat = Chat.first(sender: from, receiver: to)
    if chat.nil?
      chat = Chat.first(sender: to, receiver: from)
      if chat.nil?
        chat = CreateChat.call(
                sender_id: from_id,
                receiver_id: to_id)
      end
    end
    message.chat = chat
    message.about = about
    message.title = title
    message.from = from
    message.to = to
    message.expire_date = expire_date
    message.body = body
    message.status = status
    message.save
  end
end
