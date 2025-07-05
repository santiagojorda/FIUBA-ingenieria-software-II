class UserRepository < BaseRepository
  self.table_name = :users
  self.model_class = 'User'

  def find_by_email(email)
    row = dataset.first(email:)
    load_object(row) unless row.nil?
  end

  protected

  def changeset(user)
    {
      name: user.name,
      crypted_password: user.crypted_password,
      email: user.email,
      subscription_type: user.subscription_type
    }
  end

  def load_object(record)
    user = super
    user.subscription = case record[:subscription_type]
                        when 'on-demand' then OnDemand.new
                        when 'org' then Org.new
                        else OnDemand.new
                        end
    user
  end
end
