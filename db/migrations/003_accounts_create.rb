require 'sequel'

Sequel.migration do
  change do
    create_table(:accounts) do
      String :id, type: :uuid, primary_key: true

      String :user_name_secure, null: false
      String :email_secure, null: false
      String :password_hash_secure, null: false
      String :salt_secure, null: false

      DateTime :created_at
      DateTime :updated_at
    end
  end
end
