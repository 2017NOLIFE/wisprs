# frozen_string_literal: true
# Migration for Public keys

require 'sequel'

Sequel.migration do
  change do
    create_table(:public_keys) do
      primary_key :id
      foreign_key :owner_id, :accounts

      String :name, null: false
      String :key, null: false, unique: true
      DateTime :created_at
      DateTime :updated_at
    end
  end
end
