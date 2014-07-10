require 'spec_helper'

describe StaticController, :type => :controller do

  describe 'GET developer' do
    it 'returns http success' do
      get 'developer'
      expect(response).to be_success
    end
  end

end
