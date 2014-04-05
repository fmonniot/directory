require 'spec_helper'

describe Visit do
  context 'with elasticsearch', elasticsearch: true do
    before :each do
      Visit.recreate_search_index
    end

    it 'should return the correct facet' do
      time = Time.utc(2008, 7, 7)
      Fabricate.times(5, :visit, created_at: time)
      Visit.search_index.refresh

      expect(Visit.facet_date).to eq({ 'entries' =>[{'time'=>time.to_i * 1000, 'count' => 5}]})

    end
  end
end
