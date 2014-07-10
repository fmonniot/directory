require 'spec_helper'

describe PeopleController, type: :controller, elasticsearch: true do

  describe 'GET #index' do
    it 'responds successfully with an HTTP 200 status code' do
      get :index
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it 'renders the index template' do
      get :index
      expect(response).to render_template('index')
    end
  end

  describe 'GET #confirm' do
    before(:each) do
      person = Fabricate(:person)
      person.generate_key
      #person.save

      @key = person.key
    end

    it 'responds successfully with no key passed' do
      get :confirm_deletion, format: :json

      expect(response.status).to eq(302)
      expect(flash[:warning]).to_not be_empty
      expect(response).to redirect_to(root_url)
    end

    it 'responds successfully with an incorrect key passed' do
      get :confirm_deletion, key: 'falsekey', format: :json

      expect(response.status).to eq(302)
      expect(flash[:warning]).to_not be_empty
      expect(response).to redirect_to(root_url)
    end

    it 'responds successfully with a correct key passed' do
      get :confirm_deletion, key: @key, format: :json
        
      expect(response.status).to eq(302)
      expect(flash[:success]).to_not be_empty
      expect(response).to redirect_to(root_url)
    end
  end
end