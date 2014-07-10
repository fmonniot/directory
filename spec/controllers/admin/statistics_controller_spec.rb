require 'spec_helper'

describe Admin::StatisticsController, :type => :controller do

  let(:valid_attributes) { {  } }

  let(:valid_session) { {  } }

  sign_in_user

  describe 'GET visitors' do
    it 'should return the facet from Visit.facet_date' do
      expect(Visit).to receive(:facet_date).and_return 'facet-date'

      get :visitors, {format: 'json'}, valid_session

      expect(response.body).to eq('facet-date')
    end

    it 'should return be possible to specify the interval' do
      expect(Visit).to receive(:facet_date).with({'interval' => 'day'}).and_return 'facet-date'

      get :visitors, {format: 'json', options: {interval: 'day'}}, valid_session

      expect(response.body).to eq('facet-date')
    end
  end

  describe 'GET professions' do
    it 'should return the facet from Person.facet_profession' do
      expect(Person).to receive(:facet_profession).and_return 'facet-profession'

      get :professions, {format: 'json'}, valid_session

      expect(response.body).to eq('facet-profession')
    end
  end
end
