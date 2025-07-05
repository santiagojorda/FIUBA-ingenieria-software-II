Sequel.migration do
  up do
    add_column :users, :created_on, Date
    add_column :users, :updated_on, Date
  end

  down do
    drop_column :users, :created_on
    drop_column :users, :updated_on
  end
end
