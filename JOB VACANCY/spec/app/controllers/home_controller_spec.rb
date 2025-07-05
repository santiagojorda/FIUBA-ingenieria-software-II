require 'spec_helper'

describe 'HomeController' do
  describe 'default' do
    before :each do
      get '/'
    end

    it 'should return Comming soon!' do
      last_response.body.include? 'Comming soon!'
    end
  end
end
