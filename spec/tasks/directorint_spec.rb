require 'spec_helper'
require 'rake'

describe 'directory rake tasks' do
  before :all do
    load File.expand_path('../../../lib/tasks/directory.rake', __FILE__)
    Rake::Task.define_task(:environment)
  end

  describe 'directory:create_index' do
    before do
      Directory::Index.stub(:recreate)
    end

    it 'should create indexes' do
      Directory::Index.any_instance.should_receive :recreate

      Rake::Task['directory:create_index'].invoke
    end
  end

  describe 'directory:populate' do
    before do
      Directory::Index.stub(:populate)
    end

    it 'should create indexes' do
      Directory::Index.any_instance.should_receive :populate
      Rake::Task['directory:populate'].invoke
    end
  end

  describe 'directory:import_all' do
    before do
      Directory::LdapImport.stub(:import_all)
    end

    it 'should import records in ES' do
      Directory::LdapImport.any_instance.should_receive :import_all
      Rake::Task['directory:import_all'].invoke
    end
  end

  describe 'directory:update_people_in_school' do
    before do
      Directory::LdapImport.stub(:update_people_in_school)
    end

    it 'should update students' do
      Directory::LdapImport.any_instance.should_receive :update_people_in_school
      Rake::Task['directory:update_people_in_school'].invoke
    end
  end
end