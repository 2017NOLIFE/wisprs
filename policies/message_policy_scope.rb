# frozen_string_literal: true

# Policy to determine if account can view a chat
class MessagePolicy
  # Scope of project policies
  class Scope
    def initialize(current_account, target_account)
      @scope = all_messages(target_account)
      @current_account = current_account
      @target_account = target_account
    end

    def viewable
      if @current_account == @target_account
        @scope
      else
        @scope.select { |message| includes_receiver?(message, @current_account) }
      end
    end

    private

    def all_messages(account)
      account.sent_messages + account.received_messages
    end
    # this may be redundant, also need to refactor for chats to clean this up
    def includes_receiver?(message, account)
      message.to == account
    end
  end
end
