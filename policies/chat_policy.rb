# frozen_string_literal: true

# Policy to determine if an account can view a particular chat objects
class ChatPolicy
  def initialize(account, chat)
    @chat = chat
    @account = account
  end

  def can_view_chat?
    account_is_owner? || account_is_involved?
  end

  # duplication is ok!
  # do we want users to edit chats
  # def can_edit_chat?
  # account_is_owner? || account_is_involved?
  # end

  # do we want them to delete chats
  def can_delete_chat?
    account_is_owner?
  end

  # we implement eventually or not
  def can_remove_message?
    account_is_owner? || account_is_involved?
  end

  def summary
    {
      view_chat: can_view_chat?,
      delete_chat: can_delete_chat?,
      remove_message: can_remove_message?
    }
  end

  private

  def account_is_owner?
    @chat.sender == @account
  end

  def account_is_involved?
    @chat.receiver == @account
  end
end
