Sequel.migration do
  up do
    add_column :job_offers, :user_id, Integer
  end

  down do
    drop_column :job_offers, :user_id
  end
end
