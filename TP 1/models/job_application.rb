class JobApplication
  include ActiveModel::Validations

  attr_accessor :applicant_email, :job_offer

  validates :applicant_email, :job_offer, presence: true

  def initialize(email, offer)
    @applicant_email = email
    @job_offer = offer
    validate!
  end

  def self.create_for(email, offer)
    JobApplication.new(email, offer)
  end

  def process
    JobVacancy::App.deliver(:notification, :contact_info_email, self)
  end
end
