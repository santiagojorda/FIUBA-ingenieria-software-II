class Crypto
  def self.encrypt(password)
    ::BCrypt::Password.create(password) unless password.nil?
  end

  def self.decrypt(password)
    ::BCrypt::Password.new(password)
  end
end
