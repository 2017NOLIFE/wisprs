# frozen_string_literal: true
# Migration for Account

require 'sequel'

Sequel.migration do
  change do
    create_table(:base_accounts) do
      primary_key :id

      String :type
      String :username, null: false #, unique: true
      String :email, null: false, unique: true
      String :password_hash, text: true
      String :salt
      DateTime :created_at
      DateTime :updated_at

      unique %i[type username]
    end
  end
end
