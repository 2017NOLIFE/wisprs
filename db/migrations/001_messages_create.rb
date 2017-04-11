require 'sequel'

Sequel.migration do
  change do
    create_table(:messages) do
      primary_key :id
      String :from, null: false
      String :to, null: false
      String :title, null: false
      String :about, null: false
      String :expire_date, null: false
      Bool :status, null: false, default: false
      String :body, null: true
    end
  end
end
