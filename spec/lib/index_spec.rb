# spec/lib/index_spec.rb
require 'spec_helper'

class Model
  def self.recreate_search_index
  end

  def self.indexable
    Model
  end
  def self.import_all
  end
  def self.refresh
  end
end

describe Directory::Index do
  subject { Directory::Index.new(Model) }

  describe '#recreate' do

    it 'recreate ES index of each models' do
      expect(Model).to receive(:recreate_search_index)
      subject.recreate
    end

    context 'with many model' do
      subject { Directory::Index.new(Model, Model, Model, Model) }

      it 'recreate ES index of each models' do
        expect(Model).to receive(:recreate_search_index).exactly(4).times
        subject.recreate
      end
    end
  end

  describe '#populate' do
    before :each do
      allow(Tire).to receive(:index).and_return(Model)
      allow(Model).to receive(:index_name)
    end

    it 'should import and refresh each model ES index' do
      expect(Model).to receive(:import_all)

      expect(Tire).to receive(:index)
      expect(Model).to receive(:index_name)
      expect(Model).to receive(:refresh)

      subject.populate
    end
  end
end