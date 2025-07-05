Sequel.migration do
  up do
    create_table(:especialidades) do
      primary_key :id
      String :nombre, null: false
      Integer :tiempo_atencion, null: false
      Date :created_on
      Date :updated_on
    end
  end

  down do
    drop_table(:pacientes)
  end
end
