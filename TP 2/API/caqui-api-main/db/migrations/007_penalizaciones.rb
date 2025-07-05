Sequel.migration do
  up do
    create_table(:reputaciones) do
      primary_key :id_reputacion
      foreign_key :id_paciente, :pacientes, null: false, on_delete: :cascade
      Integer :inasistencias, default: 0, null: false
      Integer :asistencias, default: 0, null: false
      Integer :cancelaciones, default: 0, null: false
      Integer :penalizacion, default: 0, null: false
      DateTime :created_on
      DateTime :updated_on
    end
  end

  down do
    drop_table(:reputaciones)
  end
end
