# frozen_string_literal: true

# Policy to determine if account can view a chat
class ChatPolicy
  # Scope of project policies
  class Scope
    def initialize(current_account, target_account)
      @scope = all_chats(target_account)
      @current_account = current_account
      @target_account = target_account
    end

    def viewable
      if @current_account == @target_account
        @scope
      else
        @scope.select { |chat| includes_receiver?(chat, @current_account) }
      end
    end
    
    private

    def all_chats(account)
      account.sender_chats + account.receiver_chats
    end

    def includes_receiver?(chat, account)
      chat.receiver.include? account
    end
  end
end
