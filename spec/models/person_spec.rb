require 'spec_helper'

describe Person do
  before(:each) do
    @person = Fabricate(:person, login: 'login')
  end

  it 'return a correct picture source' do
    expect(@person.picture_src).to eq('28ad1ef4e2a3c59de22ced3533e1c827c495782c')
  end

  it 'return correct initials' do
    expect(@person.initials).to eq('WD')
  end

  it 'generate the correct key' do
    @person.generate_key
    expected_key = Digest::SHA1.hexdigest("#{@person.first_name}#{@person.last_name}#{Time.now}")
    expect(@person.key).to eq(expected_key)
  end

  it 'desindex correctly' do
    expect(@person.desindex).to be_true
    
    expect(@person.indexable).to be_false
  end

  context 'with elasticsearch', elasticsearch: true do
    before :each do
      Person.recreate_search_index
    end

    it 'should return the correct facet' do
      Fabricate.times(5, :person, profession: 'pro1')
      Fabricate.times(5, :person, profession: 'pro2')
      Person.search_index.refresh

      expect(Person.facet_profession).to eq({'missing' =>0,
                                             'total' =>10,
                                             'other' =>0,
                                             'terms' =>[
                                               {'term' => 'pro2', 'count' =>5},
                                               {'term' => 'pro1', 'count' =>5}
                                             ]})

    end
  end
end
