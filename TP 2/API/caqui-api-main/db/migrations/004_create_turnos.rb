Sequel.migration do
  up do
    create_table(:turnos) do
      primary_key :id
      DateTime :fecha, null: false
      foreign_key :medico_id, :medicos, type: Integer, null: false, on_delete: :cascade
      foreign_key :paciente_id, :pacientes, type: Integer, null: false, on_delete: :cascade
      Integer :asistencia, null: false
      DateTime :created_on
      DateTime :updated_on
    end
  end

  down do
    drop_table(:turnos)
  end
end
