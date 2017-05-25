# frozen_string_literal: true

# Policy to determine if account can view a message
class MessagePolicy
  def initialize(account, message)
    @account = account
    @configuration = message
  end

  def can_view?
    account_sent_message? || account_recieves_message?
  end

  def can_edit?
    account_sent_message?
  end

  def can_delete?
    account_sent_message?
  end

  def summary
    {
      view: can_view?,
      edit: can_edit?,
      delete: can_delete?
    }
  end

  private

  def account_sent_message?
    @message.from == @account
  end

  def account_recieves_message?
    @message.to == @account
  end
end
