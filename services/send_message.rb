# frozen_string_literal: true

# Service object to send a new message
require 'gpgme'

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

    email = BaseAccount.find(:id => to_id).email
    pb_key = Public_key.find(:owner_id => to_id).key
    

    message.chat = chat
    message.about = about
    message.title = title
    message.from = from
    message.to = to
    message.expire_date = expire_date
    message.body = body
    message.status = status
    message.save

    begin
      options = {}
      plain = body
      keys = pb_key

      plain_data  = GPGME::Data.new(plain)
      cipher_data = GPGME::Data.new(options[:output])
      keys        = GPGME::Key.import(pb_key)

      flags = 0
      flags |= GPGME::ENCRYPT_ALWAYS_TRUST if options[:always_trust]

      GPGME::Ctx.new(options) do |ctx|
        begin
          ctx.encrypt(keys, plain_data, cipher_data, flags)
        rescue => e
          p "#{e.message},#{e.class}"
        end
      end

      # p cipher_data
    rescue => e
      p "#{e.message}"
    end

  end

end
