require 'sequel'

Sequel.migration do
  change do
    create_table(:public_keys) do
      primary_key :id
      String :name, null: false
      String :key, null: false, unique: true
      String :owner, null: false
    end
  end
end
