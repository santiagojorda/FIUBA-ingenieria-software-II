class JobOffer
  include ActiveModel::Validations

  attr_accessor :id, :user, :user_id, :title,
                :location, :description, :remuneration, :is_active,
                :updated_on, :created_on

  validates :title, :remuneration, presence: true
  validates :remuneration, numericality: { greater_than_or_equal_to: 0 }, if: -> { remuneration.present? }

  def initialize(data = {})
    @id = data[:id]
    @title = data[:title]
    @location = data[:location]
    @description = data[:description]
    @remuneration = data[:remuneration]
    @is_active = data[:is_active]
    @updated_on = data[:updated_on]
    @created_on = data[:created_on]
    @user_id = data[:user_id]
    validate!
  end

  def remuneration_value(remuneration_string)
    if ['0', 0].include?(remuneration_string)
      0
    else
      remuneration_string = remuneration_string.to_i
      return '' if remuneration_string.zero?
    end
    remuneration_string
  end

  def owner
    user
  end

  def owner=(a_user)
    self.user = a_user
  end

  def activate
    self.is_active = true
  end

  def try_activate(active_offers)
    @user.activate_offer(self, active_offers)
  end

  def deactivate
    self.is_active = false
  end

  def old_offer?
    (Date.today - updated_on) >= 30
  end
end
