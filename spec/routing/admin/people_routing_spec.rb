require 'spec_helper'

describe Admin::PeopleController, :type => :routing do
  describe 'routing' do

    it 'routes to #index' do
      expect(get('/admin/people')).to route_to('admin/people#index')
    end

    it 'routes to #new' do
      expect(get('/admin/people/new')).to route_to('admin/people#new')
    end

    it 'routes to #show' do
      expect(get('/admin/people/1')).to route_to('admin/people#show', id: '1')
    end

    it 'routes to #edit' do
      expect(get('/admin/people/1/edit')).to route_to('admin/people#edit', id: '1')
    end

    it 'routes to #create' do
      expect(post('/admin/people')).to route_to('admin/people#create')
    end

    it 'routes to #update' do
      expect(put('/admin/people/1')).to route_to('admin/people#update', id: '1')
    end

    it 'routes to #destroy' do
      expect(delete('/admin/people/1')).to route_to('admin/people#destroy', id: '1')
    end

  end
end
