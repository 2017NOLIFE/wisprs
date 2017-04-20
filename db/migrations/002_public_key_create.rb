require 'sequel'

Sequel.migration do
  change do
    create_table(:public_keys) do
      String :id, type: :uuid, primary_key: true

      String :name_secure, null: false
      String :key_secure, null: false, unique: true
      String :owner_secure, null: false

      DateTime :created_at
      DateTime :updated_at
    end
  end
end
