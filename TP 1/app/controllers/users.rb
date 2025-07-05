JobVacancy::App.controllers :users do
  get :new, map: '/register' do
    @user = User.new
    render 'users/new'
  end

  post :create do
    user_params = params[:user]
    password_confirmation = user_params.delete(:password_confirmation)

    @user = User.new(user_params)

    unless passwords_match?(user_params[:password], password_confirmation)
      raise PasswordInvalid, 'Passwords do not match'
    end

    if !email_registered?(@user.email) && UserRepository.new.save(@user)
      flash[:success] = 'User created'
      redirect '/'
    else
      @user.errors.add(:email, 'is already registered') if email_registered?(@user.email)
      flash.now[:error] = @user.errors.full_messages.join(', ')
      render 'users/new'
    end
  rescue EmailInvalid, SubscriptionInvalid, PasswordInvalid => e
    @user ||= User.new
    flash.now[:error] = e.message
    render 'users/new'
  rescue StandardError
    @user ||= User.new
    flash.now[:error] = 'Hubo un error en el servidor'
    render 'users/new'
  end
end
