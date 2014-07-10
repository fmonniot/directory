require 'spec_helper'

describe 'admin/people/edit', :type => :view do
  before(:each) do
    @person = assign(:person, stub_model(Person))
  end

  it 'renders the edit admin_person form' do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select 'form[action=?][method=?]', admin_person_path(@person), 'post' do
    end
  end
end
