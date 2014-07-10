require 'spec_helper'

describe 'admin/people/index', :type => :view do
  before(:each) do
    assign(:people, Kaminari.paginate_array([
      Fabricate(:person),
      Fabricate(:person)
    ]).page(1))
  end

  it 'renders a list of admin/people' do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
