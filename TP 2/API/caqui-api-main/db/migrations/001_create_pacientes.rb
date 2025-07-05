Sequel.migration do
  up do
    create_table(:pacientes) do
      primary_key :id
      String :nombre
      Integer :dni
      String :email
      Date :created_on
      Date :updated_on
    end
  end

  down do
    drop_table(:pacientes)
  end
end
