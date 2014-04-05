require 'spec_helper'

describe Admin::StatisticsController do
  describe 'routing' do

    it 'routes to #index' do
      get('/admin/statistics/visitors').should route_to('admin/statistics#visitors')
    end

  end
end
