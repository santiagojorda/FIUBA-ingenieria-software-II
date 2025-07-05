Sequel.migration do
  up do
    from(:job_offers).update(is_active: true)
  end

  down do
  end
end
