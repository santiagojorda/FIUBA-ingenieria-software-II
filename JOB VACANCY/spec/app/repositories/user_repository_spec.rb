require 'integration_spec_helper'

describe UserRepository do
  let(:repository) { described_class.new }

  it 'should find by email' do
    joe_user = User.new(name: 'Joe', email: 'joe@doe.com', crypted_password: 'secure_pwd')
    repository.save(joe_user)

    found_user = repository.find_by_email(joe_user.email)

    expect(found_user.email).to eq joe_user.email
    expect(found_user.id).to eq joe_user.id
  end

  it 'should retrieve all users' do
    initial_user_count = repository.all.size
    some_user = User.new(name: 'Joe', email: 'joe@doe.com', crypted_password: 'secure_pwd')
    repository.save(some_user)

    users = repository.all

    expect(users.size).to eq(initial_user_count + 1)
  end
end
