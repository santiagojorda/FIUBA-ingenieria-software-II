class JobOfferFavorite
  include ActiveModel::Validations

  attr_accessor :id, :updated_on, :created_on
  attr_reader :job_offer_id, :user_id

  validates :job_offer_id, :user_id, presence: true

  def initialize(data = {})
    @id = data[:id]
    @job_offer_id = data[:job_offer_id]
    @user_id = data[:user_id]
    @updated_on = data[:updated_on]
    @created_on = data[:created_on]
    validate!
  end
end
