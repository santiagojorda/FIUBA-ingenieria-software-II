Sequel.migration do
  up do
    create_table(:pings) do
      primary_key :id
      String :description
      DateTime :created_at
    end
  end

  down do
    drop_table(:pings)
  end
end
