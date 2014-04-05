require 'spec_helper'

describe 'admin/people/new' do
  before(:each) do
    assign(:person, stub_model(Person).as_new_record)
  end

  it 'renders new admin_person form' do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select 'form[action=?][method=?]', admin_people_path, 'post' do
    end
  end
end
