require 'sequel'
require 'sinatra'

Sequel.migration do
  change do
    create_table(:messages) do
      String :id, type: :uuid, primary_key: true

      String :from_secure, null: false
      String :to_secure, null: false
      String :title_secure, null: false
      String :about_secure, null: false
      String :expire_date, null: false
      String :status_secure, null: false, default: 'NO'

      # secure data - initialize as nil until data provided
      String :body_secure, null: false #, text: true

      DateTime :created_at
      DateTime :updated_at
    end
  end
end
