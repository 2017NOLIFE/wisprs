require 'sequel'
require 'sinatra'

Sequel.migration do
  change do
    create_table(:messages) do
      String :id, type: :uuid, primary_key: true

      String :from, null: false
      String :to, null: false
      String :title, null: false
      String :about, null: false
      String :expire_date, null: false
      Bool :status, null: false, default: false

      # secure data - initialize as nil until data provided
      String :body_secure, text: true

      DateTime :created_at
      DateTime :updated_at
    end
  end
end
