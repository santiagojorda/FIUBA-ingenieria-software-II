class GateKeeper
  def initialize
    @auth_succeed = false
  end

  def authenticate(email, password)
    @user = UserRepository.new.find_by_email(email)
    @auth_succeed = true if @user&.has_password?(password)
    self
  end

  def when_succeed
    yield(@user) if @auth_succeed
    self
  end

  def when_failed
    yield unless @auth_succeed
    self
  end
end
