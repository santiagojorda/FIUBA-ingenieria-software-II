JobVacancy::App.controllers :users do
  get :new, map: '/register' do
    @user = User.new
    render 'users/new'
  end

  post :create do
    password_confirmation = params[:user][:password_confirmation]
    params[:user].reject! { |k, _| k == 'password_confirmation' }

    @user = User.new(params[:user])

    if params[:user][:password] == password_confirmation
      if UserRepository.new.save(@user)
        flash[:success] = 'User created'
        redirect '/'
      else
        flash.now[:error] = @user.errors.full_messages.join(', ')
        render 'users/new'
      end
    else
      flash.now[:error] = 'Passwords do not match'
      render 'users/new'
    end
  end
end
