Sequel.migration do
  up do
    create_table(:job_offers) do
      primary_key :id
      String :title
      String :location
      String :description
    end
  end

  down do
    drop_table(:job_offers)
  end
end
