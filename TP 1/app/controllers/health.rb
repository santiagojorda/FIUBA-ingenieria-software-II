JobVacancy::App.controllers :health do
  get :index do
    logger.info 'health'
    ping = Ping.create(description: 'health-controller')
    if ping.nil?
      status 500
    else
      status 200
      'ok'
    end
  end

  get :stats, provides: [:json] do
    { offers_count: JobOffer.count, users_count: User.count }.to_json
  end

  get :version do
    Version.current
  end

  get :reset do
    # JobOffer.destroy
    JobOfferRepository.new.delete_all
    UserRepository.new.delete_all
    #     user = User.create(email: 'offerer@test.com',
    #                        name: 'Offerer',
    #                        password: 'Passw0rd!')
    #     JobOffer.create(title: 'Java programmer',
    #                     user: user,
    #                     description: 'Spring experience required',
    #                     location: 'Cordoba')
    #     JobOffer.create(title: 'Web programmer',
    #                     user: user,
    #                     description: 'HTML5 experience required',
    #                     location: 'Rosario')
    'ok'
  end
end
