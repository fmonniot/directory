require 'spec_helper'
require 'rake'

describe 'directory rake tasks' do
  before :all do
    load File.expand_path('../../../lib/tasks/directory.rake', __FILE__)
    Rake::Task.define_task(:environment)
  end

  describe 'directory:create_index' do
    before do
      allow(Directory::Index).to receive(:recreate)
    end

    it 'should create indexes' do
      expect_any_instance_of(Directory::Index).to receive :recreate

      Rake::Task['directory:create_index'].invoke
    end
  end

  describe 'directory:populate' do
    before do
      allow(Directory::Index).to receive(:populate)
    end

    it 'should create indexes' do
      expect_any_instance_of(Directory::Index).to receive :populate
      Rake::Task['directory:populate'].invoke
    end
  end

  describe 'directory:import_all' do
    before do
      allow(Directory::LdapImport).to receive(:import_all)
    end

    it 'should import records in ES' do
      expect_any_instance_of(Directory::LdapImport).to receive :import_all
      Rake::Task['directory:import_all'].invoke
    end
  end

  describe 'directory:update_people_in_school' do
    before do
      allow(Directory::LdapImport).to receive(:update_people_in_school)
    end

    it 'should update students' do
      expect_any_instance_of(Directory::LdapImport).to receive :update_people_in_school
      Rake::Task['directory:update_people_in_school'].invoke
    end
  end
end