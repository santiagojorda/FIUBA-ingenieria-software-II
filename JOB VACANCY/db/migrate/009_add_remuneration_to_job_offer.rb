Sequel.migration do
  up do
    add_column :job_offers, :remuneration, Integer, default: 0
  end

  down do
    drop_column :job_offers, :remuneration
  end
end
  