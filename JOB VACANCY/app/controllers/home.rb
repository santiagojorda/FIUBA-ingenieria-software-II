JobVacancy::App.controllers :home do
  get :index, map: '/' do
    render 'home/index'
  end

  get :about do
    render 'home/about'
  end
end
