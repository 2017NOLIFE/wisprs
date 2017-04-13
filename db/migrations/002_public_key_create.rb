require 'sequel'

Sequel.migration do
  change do
    create_table(:public_keys) do
      primary_key :id
      String :key, null: false
      String :owner, null: false
    end
  end
end
