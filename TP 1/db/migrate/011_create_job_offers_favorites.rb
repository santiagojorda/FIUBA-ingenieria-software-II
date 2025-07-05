Sequel.migration do
  up do
    create_table(:job_offers_favorites) do
      primary_key :id
      foreign_key :job_offer_id, :job_offers
      foreign_key :user_id, :users
      Date :created_on
      Date :updated_on
    end
  end

  down do
    drop_table(:job_offers_favorites)
  end
end
