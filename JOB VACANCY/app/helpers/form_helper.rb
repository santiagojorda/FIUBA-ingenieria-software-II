# Helper methods defined here can be accessed in any controller or view in the application

JobVacancy::App.helpers do
  def errors_for(errors, field)
    "<div class=\"alert alert-error\">#{@errors[field].join(' - ')}</div>".html_safe if
        errors && !errors[field].empty?
  end
end
