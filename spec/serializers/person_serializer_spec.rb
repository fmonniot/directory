# spec/serializers/person_serializer_spec.rb
require 'spec_helper'

describe PersonSerializer do
  it 'creates special JSON for the API' do
    person = Fabricate(:person)
    serializer = PersonSerializer.new person
    expect(serializer.to_json).to eql('{"person":{"id":"'+person.id+'",'+
      '"first_name":"William","last_name":"Dalton","profession":null,'+
      '"email":"william.dalton@texas.us","year_entrance":'+Time.now.year.to_s+','+
      '"year_out":null,"picture_src":"28ad1ef4e2a3c59de22ced3533e1c827c495782c"}}')
  end
end