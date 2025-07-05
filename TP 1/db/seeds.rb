require_relative '../models/user'
require_relative '../models/job_offer'
user_repository = UserRepository.new
unless user_repository.all.count.positive?
  test_user = User.new(email: 'offerer@test.com',
                       name: 'Offerer',
                       password: 'Pass12$ord!45')
  user_repository.save test_user
  test_user2 = User.new(email: 'other_offerer@test.com',
                        name: 'Other Offerer',
                        password: 'Pass12$ord!45')
  user_repository.save test_user2
end
