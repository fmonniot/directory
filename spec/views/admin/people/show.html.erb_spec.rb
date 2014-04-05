require 'spec_helper'

describe 'admin/people/show' do
  before(:each) do
    @person = assign(:person, Fabricate(:person))
  end

  it 'renders attributes in <p>' do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
