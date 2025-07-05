require_relative 'subscriptions/on_demand'
require_relative 'subscriptions/subscription_factory'
class User
  include ActiveModel::Validations

  MIN_PASSWORD_LENGTH = 8
  MAX_PASSWORD_LENGTH = 15
  ALLOWED_SPECIAL_CHARS = '!@#$%^&*+=(){}:;?_-.¿!/'.freeze
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d-]+(\.[a-z]+)*\.[a-z]+\z/i

  attr_accessor :id, :name, :email, :crypted_password, :updated_on, :created_on, :subscription

  validates :name, :crypted_password, presence: true
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX,
                                              message: 'invalid' }

  def self.create(name, email, password)
    data = {}
    data[:name] = name
    data[:email] = email
    data[:password] = password
    User.new(data)
  end

  def initialize(data = {})
    @id = data[:id]
    @name = data[:name]
    @email = data[:email]
    @crypted_password = process_password(data)
    @updated_on = data[:updated_on]
    @created_on = data[:created_on]
    subs_factory = SubscriptionFactory.new
    @subscription = subs_factory.create(data[:subscription], @email)
  end

  def has_password?(password)
    Crypto.decrypt(crypted_password) == password
  end

  def calculate_amount_to_pay(active_offers)
    @subscription.calculate_costs(active_offers)
  end

  def subscription_type
    @subscription.type
  end

  def activate_offer(job_offer, active_offers)
    @subscription.activate_offer(job_offer, active_offers)
  end

  private

  def process_password(data)
    if data[:password].nil?
      data[:crypted_password]
    else
      validate_password(data[:password])
      Crypto.encrypt(data[:password])
    end
  end

  def validate_password(password)
    raise PasswordInvalid, 'Password must be at least 8 characters long' if password.length < MIN_PASSWORD_LENGTH
    raise PasswordInvalid, 'Password must contain at least one uppercase letter' unless password.match?(/[A-Z]/)
    raise PasswordInvalid, 'Password must contain at least two numbers' unless password.match?(/\d.*\d/)
    raise PasswordInvalid, 'Password must not exceed 15 characters' if password.length > MAX_PASSWORD_LENGTH

    unless password.match?(/[#{Regexp.escape(ALLOWED_SPECIAL_CHARS)}]/)
      raise PasswordInvalid,
            'Password must contain at least one special character'
    end
  end
end
