# frozen_string_literal: true

# Migration for Message table

require 'sequel'
require 'sinatra'

Sequel.migration do
  change do
    create_table(:messages) do
      primary_key :id
      foreign_key :chat_id, :chats

      foreign_key :from_id, :base_accounts
      foreign_key :to_id, :base_accounts
      String :title_secure, null: false
      String :about_secure, null: false
      String :expire_date, null: false
      String :status_secure, null: false, default: 'UNREAD'

      # secure data - initialize as nil until data provided
      String :body_secure, null: false #, text: true

      DateTime :created_at
      DateTime :updated_at
    end
  end
end
