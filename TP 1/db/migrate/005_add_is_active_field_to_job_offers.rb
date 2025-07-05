Sequel.migration do
  up do
    add_column :job_offers, :is_active, TrueClass, default: true
  end

  down do
    drop_column :job_offers, :is_active
  end
end
