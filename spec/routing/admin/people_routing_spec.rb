require 'spec_helper'

describe Admin::PeopleController do
  describe 'routing' do

    it 'routes to #index' do
      get('/admin/people').should route_to('admin/people#index')
    end

    it 'routes to #new' do
      get('/admin/people/new').should route_to('admin/people#new')
    end

    it 'routes to #show' do
      get('/admin/people/1').should route_to('admin/people#show', id: '1')
    end

    it 'routes to #edit' do
      get('/admin/people/1/edit').should route_to('admin/people#edit', id: '1')
    end

    it 'routes to #create' do
      post('/admin/people').should route_to('admin/people#create')
    end

    it 'routes to #update' do
      put('/admin/people/1').should route_to('admin/people#update', id: '1')
    end

    it 'routes to #destroy' do
      delete('/admin/people/1').should route_to('admin/people#destroy', id: '1')
    end

  end
end
