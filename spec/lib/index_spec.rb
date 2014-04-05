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
      Model.should_receive(:recreate_search_index)
      subject.recreate
    end

    context 'with many model' do
      subject { Directory::Index.new(Model, Model, Model, Model) }

      it 'recreate ES index of each models' do
        Model.should_receive(:recreate_search_index).exactly(4).times
        subject.recreate
      end
    end
  end

  describe '#populate' do
    before :each do
      Tire.stub(:index).and_return(Model)
      Model.stub(:index_name)
    end

    it 'should import and refresh each model ES index' do
      Model.should_receive(:import_all)

      Tire.should_receive(:index)
      Model.should_receive(:index_name)
      Model.should_receive(:refresh)

      subject.populate
    end
  end
end