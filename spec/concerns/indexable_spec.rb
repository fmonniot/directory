require 'spec_helper'

class IndexableTest
  include Indexable
end

describe Indexable do

  describe '#search_index' do
    before :each do
      expect(Tire).to receive(:index).with('directory_test_indexabletests').and_return(:index)
    end

    it 'should return the Tire index' do
      expect(IndexableTest.search_index).to eq(:index)
    end
  end

  describe 'create_search_index' do
    before :each do
      expect(Tire).to receive(:index).with('directory_test_indexabletests').and_return(:index)
    end

    it 'should create the index' do
      expect(IndexableTest.create_search_index).to eq(:index)
    end
  end

  describe 'delete_search_index' do
    before :each do
      allow(Tire).to receive_message_chain(:index, :delete).and_return(:deleted)
    end

    it 'should create the index' do
      expect(IndexableTest.delete_search_index).to eq(:deleted)
    end
  end

  describe 'recreate_search_index' do
    before :each do
      expect(IndexableTest).to receive(:delete_search_index)
      expect(IndexableTest).to receive(:create_search_index)
    end

    it 'should create the index' do
      IndexableTest.recreate_search_index
    end
  end
end