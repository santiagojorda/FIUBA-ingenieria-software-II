Sequel.migration do
  up do
    alter_table(:pacientes) do
      add_column :telegram_username, String
    end
  end

  down do
    alter_table(:pacientes) do
      drop_column :telegram_username
    end
  end
end
