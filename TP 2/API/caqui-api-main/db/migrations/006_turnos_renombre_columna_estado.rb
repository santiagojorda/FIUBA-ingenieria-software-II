Sequel.migration do
  change do
    rename_column :turnos, :asistencia, :estado
  end
end
