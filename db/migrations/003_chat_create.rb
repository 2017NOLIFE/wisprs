# frozen_string_literal: true

# Migration for Chat table

require 'sequel'

Sequel.migration do
  change do
    create_table(:chats) do
      primary_key :id
      foreign_key :sender_id, :accounts, null: false
      foreign_key :receiver_id, :accounts, null: false
      unique %i[sender_id receiver_id]
    end
  end
end
