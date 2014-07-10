require 'spec_helper'

describe Admin::StatisticsController, :type => :routing do
  describe 'routing' do

    it 'routes to #index' do
      expect(get('/admin/statistics/visitors')).to route_to('admin/statistics#visitors')
    end

  end
end
