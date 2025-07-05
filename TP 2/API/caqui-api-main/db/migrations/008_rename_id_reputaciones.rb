Sequel.migration do
  up do
    alter_table(:reputaciones) do
      rename_column :id_reputacion, :id
    end
  end

  down do
    alter_table(:reputaciones) do
      rename_column :id, :id_reputacion
    end
  end
end
