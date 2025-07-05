Sequel.migration do
  up do
    create_table(:medicos) do
      primary_key :id
      String :nombre, null: false
      String :matricula, unique: true, null: false
      TrueClass :trabaja_feriados, null: false
      foreign_key :especialidad_id, :especialidades, null: false, on_delete: :restrict
      DateTime :created_on
      DateTime :updated_on
    end
  end

  down do
    drop_table(:medicos)
  end
end
