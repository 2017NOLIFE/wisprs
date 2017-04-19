require 'sequel'

Sequel.migration do
  change do
    create_table(:public_keys) do
      String :id, type: :uuid, primary_key: true
      
      String :name, null: false
      String :key, null: false, unique: true
      String :owner, null: false

      DateTime :created_at
      DateTime :updated_at
    end
  end
end
