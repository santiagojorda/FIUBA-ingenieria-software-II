module ValidationHelpers
  def check_validation(field_name, error_message)
    yield
    raise('Error not thrown')
  rescue ActiveModel::ValidationError => e
    expect(e.message).to eq("Validation failed: #{error_message}")
    expect(e.model.errors).to have_key(field_name)
  end
end
