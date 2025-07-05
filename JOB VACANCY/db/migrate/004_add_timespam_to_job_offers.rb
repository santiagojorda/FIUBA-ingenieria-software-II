Sequel.migration do
  up do
    add_column :job_offers, :created_on, Date
    add_column :job_offers, :updated_on, Date
  end

  down do
    drop_column :job_offers, :created_on
    drop_column :job_offers, :updated_on
  end
end
