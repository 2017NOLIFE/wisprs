# frozen_string_literal: true

# Service object to send a new message
require 'gpgme'

class SendMessage
  def self.call(from_id:, to_id:, title:, about:, expire_date:, status:, body:, receiver_name:)
    p receiver_name
    to_id = BaseAccount.find(:username => receiver_name).id
    begin
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

    rescue => e
      p "#{e.message}!!!"
    end

    begin
      key = GPGME::Data.new(pb_key.to_s)
      data = GPGME::Data.new(body.to_s)

      ctx = GPGME::Ctx.new :keylist_mode => GPGME::KEYLIST_MODE_EXTERN
      ctx.import_keys(key)
      crypto = GPGME::Crypto.new(:armor => true, :always_trust => true)
      e = crypto.encrypt(data)
    rescue => e
      p "#{e.message},#{e.class}"
    end

    message.chat = chat
    message.about = about
    message.title = title
    message.from = from
    message.to = to
    message.expire_date = expire_date
    message.body = e.to_s
    message.status = status
    message.save


  end

end
