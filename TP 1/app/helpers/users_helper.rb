# Helper methods defined here can be accessed in any controller or view in the application

JobVacancy::App.helpers do
  def email_registered?(email)
    UserRepository.new.find_by_email(email)
  end

  def passwords_match?(password, confirmation)
    password == confirmation
  end
end
