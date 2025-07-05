class SubscriptionFactory
  def create(subscription, email)
    case subscription
    when ''
      raise SubscriptionInvalid, 'Please select a subscription type to continue'
    when 'on-demand'
      OnDemand.new
    when 'org'
      if email.end_with?('.org')
        Org.new
      else
        raise EmailInvalid, 'Email is not valid for this subscription'
      end
    else
      OnDemand.new
    end
  end
end
