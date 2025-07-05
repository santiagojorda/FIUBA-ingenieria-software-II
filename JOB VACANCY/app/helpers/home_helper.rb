# Helper methods defined here can be accessed in any controller or view in the application

JobVacancy::App.helpers do
  # def simple_helper_method
  #  ...
  # end
  def feature_enabled?(feature_name)
    ENV[feature_name.to_s] == 'true'
  end
end
