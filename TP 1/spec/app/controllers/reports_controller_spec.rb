describe 'ReportsController' do
  describe 'get :billing /reports/billing' do
    it 'should respond ok' do
      get '/reports/billing', {}
      expect(last_response).to be_ok
    end

    it 'should not return null with total_active_offers' do
      get '/reports/billing', {}
      json = JSON.parse(last_response.body)
      expect(json['total_active_offers']).not_to be_nil
    end

    it 'should not return null with total_amount' do
      get '/reports/billing', {}
      json = JSON.parse(last_response.body)
      expect(json['total_amount']).not_to be_nil
    end

    it 'items exist in json' do
      get '/reports/billing', {}
      json = JSON.parse(last_response.body)
      expect(json['items']).not_to be_nil
    end
  end
end
