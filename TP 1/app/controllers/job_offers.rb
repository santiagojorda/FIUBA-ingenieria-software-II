JobVacancy::App.controllers :job_offers do
  get :my do
    @offers = JobOfferRepository.new.find_by_owner(current_user)
    render 'job_offers/my_offers'
  end

  get :index do
    @offers = JobOfferRepository.new.all_active
    render 'job_offers/list'
  end

  get :new do
    @job_offer = JobOfferForm.new
    render 'job_offers/new'
  end

  get :latest do
    @offers = JobOfferRepository.new.all_active
    render 'job_offers/list'
  end

  get :edit, with: :offer_id do
    @job_offer = JobOfferForm.from(JobOfferRepository.new.find(params[:offer_id]))
    # TODO: validate the current user is the owner of the offer
    render 'job_offers/edit'
  end

  get :apply, with: :offer_id do
    @job_offer = JobOfferForm.from(JobOfferRepository.new.find(params[:offer_id]))
    @job_application = JobApplicationForm.new
    # TODO: validate the current user is the owner of the offer
    render 'job_offers/apply'
  end

  post :search do
    @offers = JobOfferRepository.new.search_by_title(params[:q])
    render 'job_offers/list'
  end

  post :apply, with: :offer_id do
    @job_offer = JobOfferRepository.new.find(params[:offer_id])
    applicant_email = params[:job_application_form][:applicant_email]
    unless validate_email(applicant_email)
      flash[:error] = 'Email invalid'
      redirect '/job_offers'
    end
    @job_application = JobApplication.create_for(applicant_email, @job_offer)
    @job_application.process
    flash[:success] = 'Contact information sent.'
    redirect '/job_offers'
  end

  post :create do
    job_offer = JobOffer.new(job_offer_params)
    job_offer.owner = current_user
    if JobOfferRepository.new.save(job_offer)
      flash[:success] = 'Offer created'
      redirect '/job_offers/my'
    end
  rescue ActiveModel::ValidationError => e
    @job_offer = JobOfferForm.new
    @errors = e.model.errors
    flash.now[:error] = 'Please review the errors'
    render 'job_offers/new'
  end

  post :update, with: :offer_id do
    @job_offer = JobOffer.new(job_offer_params.merge(id: params[:offer_id]))
    @job_offer.owner = current_user

    if JobOfferRepository.new.save(@job_offer)
      flash[:success] = 'Offer updated'
      redirect '/job_offers/my'
    end
  rescue ActiveModel::ValidationError => e
    @job_offer = JobOfferForm.new
    @errors = e.model.errors
    flash.now[:error] = 'Please review the errors'
    render 'job_offers/edit'
  end

  post :favorite do
    @offers = JobOfferRepository.new.all_active

    job_offer_id = params[:job_offer_id]
    job_offer = JobOfferRepository.new.find(job_offer_id)
    unless job_offer.valid?
      flash.now[:error] = 'Job offer ID does not exist'
      redirect 'job_offers'
    end

    user_id = params[:user_id]
    user = UserRepository.new.find(user_id)
    unless user.valid?
      flash.now[:error] = 'User ID does not exist'
      redirect 'job_offers'
    end

    JobOfferFavoriteRepository.new.save(job_offer, user)
    flash[:success] = 'Offer added to favorite list successfully'
    redirect 'job_offers'

  rescue JobOfferFavoriteError => e
    flash.now[:error] = e.message
    render 'job_offers/list'
  rescue StandardError
    flash.now[:error] = 'Hubo un error en el servidor'
    render 'job_offers/list'
  end

  put :activate, with: :offer_id do
    job_offers_repo = JobOfferRepository.new
    @job_offer = job_offers_repo.find(params[:offer_id])
    offer_counter = OfferCounter.new(job_offers_repo)
    active_offers = offer_counter.users_active_offers(current_user.email)
    @job_offer.try_activate(active_offers)
    if JobOfferRepository.new.save(@job_offer)
      flash[:success] = 'Offer activated'
    else
      flash.now[:error] = 'Operation failed'
    end

    redirect '/job_offers/my'
  end

  delete :destroy do
    @job_offer = JobOfferRepository.new.find(params[:offer_id])
    if JobOfferRepository.new.destroy(@job_offer)
      flash[:success] = 'Offer deleted'
    else
      flash.now[:error] = 'Title is mandatory'
    end
    redirect 'job_offers/my'
  end
end
