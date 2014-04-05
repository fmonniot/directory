# spec/requests/api/v1/v1/messages_spec.rb
require 'spec_helper'

describe 'People API', elasticsearch: true do

  before(:all) do
    Fabricate.times(151, :person)
    Fabricate(:person, first_name: 'test', last_name:'spec')
    Person.search_index.refresh
  end

  it 'retrieves a list of people' do
    get '/api/v1/people', format: :json

    # test for the 200 status-code
    expect(response).to be_success

    # check to make sure the right number of people are returned
    expect(json['people'].length).to eq(25)
  end

  # Should use Hash for parameters
  def testing_params_header(q, type, page)
    expect(response.headers['X-Params']).to eq("#{q}; #{type}; #{page}")
  end

  context 'when searching someone' do

    it 'search people which name is `d`' do
      get '/api/v1/people/search', q: 'd', format: :json
      
      testing_params_header('d', 'n', 1)
    end

    it 'search people which initials are `wd`' do
      get '/api/v1/people/search', q: 'wd', type: 'i', format: :json
      
      testing_params_header('wd', 'i', 1)
    end

    it 'search people which initials are `w.d`' do
      get '/api/v1/people/search', q: 'w.d', type: 'i', format: :json

      testing_params_header('w.d', 'i', 1)
    end

    it 'search people which initials are `w d`' do
      get '/api/v1/people/search', q: 'w d', type: 'i', format: :json
      
      testing_params_header('w d', 'i', 1)
    end

    it 'search people which initials are `w-d`' do
      get '/api/v1/people/search', q: 'w-d', type: 'i', format: :json
      
      testing_params_header('w-d', 'i', 1)
    end
  end

  context 'when there is one person' do
    before(:each) do
      @person = Fabricate(:person)
    end

    it 'retrieves a specific person' do
      
      get "/api/v1/people/#{@person.id}", format: :json

      # test for the 200 status-code
      expect(response).to be_success

      # check that the person attributes are the same
      expect(response.body).to eq(PersonSerializer.new(@person).to_json)
    end
  end

  context 'want to delete someone' do
    before(:each) do
      @person = Fabricate(:person)
    end

    it 'responds with 404' do
      delete '/api/v1/people/2474', format: :json
      expect(response.status).to eq(404)
    end

    it 'is correctly marked to delete' do
      delete "/api/v1/people/#{@person.id}", format: :json
      saved_id = Person.find(@person.id).id

      expect(response).to be_success
      expect(response.body).to eq('{"person":{"id":"'+saved_id+'","first_name":"William",'+
        '"last_name":"Dalton","profession":null,'+
        '"email":"william.dalton@texas.us","year_entrance":'+Time.now.year.to_s+','+
        '"year_out":null,"picture_src":"28ad1ef4e2a3c59de22ced3533e1c827c495782c"},"confirmation_url":'+
        '"http://www.example.com/api/v1/people/'+saved_id+'"}')
    end

    it 'is effectively desindexed' do
      @person.generate_key
      delete "/api/v1/people/#{@person.id}?key=#{@person.key}", format: :json

      expect(response).to be_success
    end
  end

  context 'verifying Link pagination' do

    it 'is the first page' do
      get '/api/v1/people/search', q: 'd', page: 1, format: :json

      expect(response.headers['Link']).to eq(
        "<https://trombint.minet.net/api/v1/people?q=d&type=n&page=1>; rel=\"first\", "+
        "<https://trombint.minet.net/api/v1/people?q=d&type=n&page=2>; rel=\"next\", "+
        "<https://trombint.minet.net/api/v1/people?q=d&type=n&page=7>; rel=\"last\"")
    end

    it 'is the second page' do
      get '/api/v1/people/search', q: 'd', page: 2, format: :json

      expect(response.headers['Link']).to eq(
        "<https://trombint.minet.net/api/v1/people?q=d&type=n&page=1>; rel=\"first\", "+
        "<https://trombint.minet.net/api/v1/people?q=d&type=n&page=1>; rel=\"prev\", "+
        "<https://trombint.minet.net/api/v1/people?q=d&type=n&page=3>; rel=\"next\", "+
        "<https://trombint.minet.net/api/v1/people?q=d&type=n&page=7>; rel=\"last\"")
    end

    it 'has a page before and after' do
      get '/api/v1/people/search', q: 'd', page: 3, format: :json

      expect(response.headers['Link']).to eq(
        "<https://trombint.minet.net/api/v1/people?q=d&type=n&page=1>; rel=\"first\", "+
        "<https://trombint.minet.net/api/v1/people?q=d&type=n&page=2>; rel=\"prev\", "+
        "<https://trombint.minet.net/api/v1/people?q=d&type=n&page=4>; rel=\"next\", "+
        "<https://trombint.minet.net/api/v1/people?q=d&type=n&page=7>; rel=\"last\"")
    end

    it 'is the before last page' do
      get '/api/v1/people/search', q: 'd', page: 6, format: :json

      expect(response.headers['Link']).to eq(
        "<https://trombint.minet.net/api/v1/people?q=d&type=n&page=1>; rel=\"first\", "+
        "<https://trombint.minet.net/api/v1/people?q=d&type=n&page=5>; rel=\"prev\", "+
        "<https://trombint.minet.net/api/v1/people?q=d&type=n&page=7>; rel=\"next\", "+
        "<https://trombint.minet.net/api/v1/people?q=d&type=n&page=7>; rel=\"last\"")
    end

    it 'is the last page' do
      get '/api/v1/people/search', q: 'd', page: 7, format: :json

      expect(response.headers['Link']).to eq(
        "<https://trombint.minet.net/api/v1/people?q=d&type=n&page=1>; rel=\"first\", "+
        "<https://trombint.minet.net/api/v1/people?q=d&type=n&page=6>; rel=\"prev\", "+
        "<https://trombint.minet.net/api/v1/people?q=d&type=n&page=7>; rel=\"last\"")
    end

    it 'has one result' do
      get '/api/v1/people/search', q: 'spec', page: 1, format: :json

      expect(response.headers['Link']).to eq(
        "<https://trombint.minet.net/api/v1/people?q=spec&type=n&page=1>; rel=\"first\", "+
        "<https://trombint.minet.net/api/v1/people?q=spec&type=n&page=1>; rel=\"last\"")
    end
  end

  context 'limiting pagination' do

    it 'limit by default to 25 people' do
      get '/api/v1/people', format: :json

      # check to make sure the right number of people are returned
      expect(json['people'].length).to eq(25)
    end

    it 'should be posible to change the number of people per page' do
      get '/api/v1/people?per_page=10', format: :json

      # check to make sure the right number of people are returned
      expect(json['people'].length).to eq(10)
    end

    it 'should limit the number of people per page' do
      get '/api/v1/people?per_page=105', format: :json

      # check to make sure the right number of people are returned
      expect(json['people'].length).to eq(100)
    end

  end
end
