# Find all messages (sent and received) by an account
class FindAllAccountMessages
  def self.call(id:)
    account = Account.where(id: id).first
    account.sent_messages + account.received_messages
  end
end
