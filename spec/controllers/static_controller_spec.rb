require 'spec_helper'

describe StaticController do

  describe 'GET developer' do
    it 'returns http success' do
      get 'developer'
      response.should be_success
    end
  end

end
