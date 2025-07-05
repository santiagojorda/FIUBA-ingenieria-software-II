JobVacancy::App.controllers :sessions do
  get :login, map: '/login' do
    @user = User.new
    render 'sessions/new'
  end

  post :create do
    email = params[:user][:email]
    password = params[:user][:password]

    gate_keeper = GateKeeper.new.authenticate(email, password)

    gate_keeper.when_succeed do |user|
      @user = user
      sign_in @user
      redirect '/'
    end

    gate_keeper.when_failed do
      @user = User.new
      flash[:error] = 'Invalid credentials'
      redirect '/login'
    end
  end

  get :destroy, map: '/logout' do
    sign_out
    redirect '/'
  end
end
