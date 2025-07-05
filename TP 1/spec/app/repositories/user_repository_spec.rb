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

  it 'should return the OnDemand subscription' do
    fran_user = User.new(name: 'fran', email: 'fran@doe.com', crypted_password: 'leia')
    fran_user.subscription = OnDemand.new
    repository.save(fran_user)
    found_user = repository.find_by_email(fran_user.email)
    expect(found_user.subscription).to be_a(OnDemand)
  end

  it 'should return the Org subscription' do
    p_user = User.new(name: 'pedro', email: 'fran@doe.org', crypted_password: 'leia')
    p_user.subscription = Org.new
    repository.save(p_user)
    found_user = repository.find_by_email(p_user.email)
    expect(found_user.subscription).to be_a(Org)
  end
end
