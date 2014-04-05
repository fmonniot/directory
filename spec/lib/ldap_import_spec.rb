# spec/lib/index_spec.rb
require 'spec_helper'

describe Directory::LdapImport do

  subject { Directory::LdapImport.new({ host: 'localhost', port: 3006, treebase: '' }) }

  let(:person) { double('Person', picture_src: 'testpicture', login: 'login', picture?: true, year_out: Time.now.year) }
  let(:entry) { double('Entry', uid: ['logindoesntexist'],
                       givenname: ['first_name'],
                       sn: ['sn'],
                       title: ['title'],
                       mail: ['walke@alone.org']) }

  describe '#filter_uid_ou_present' do
    it 'should return the correct filter' do
      expect(subject.filter_uid_ou_present).to eq(Net::LDAP::Filter.join(
        Net::LDAP::Filter.present('uid'),
        Net::LDAP::Filter.present('ou'))
      )
    end
  end

  describe '#import_all' do
    it 'import each person found in ldap' do
      subject.ldap.should_receive(:search).and_yield :entry
      subject.should_receive(:import_one).once

      subject.import_all
    end
  end

  describe '#import_one' do
    
    context 'when the person is not in db' do

      before :each do
        Person.find_or_initialize_by(
          login: entry.uid.first.force_encoding('utf-8'),
          first_name: entry.givenname.first.force_encoding('utf-8'),
          last_name: entry.sn.first.force_encoding('utf-8'),
          email: entry.mail.first.force_encoding('utf-8'),
          year_entrance: Time.now.year).delete

        PictureUploader.stub(:download!)
      end

      it 'save the person' do
        subject.import_one entry

        expect(Person.where(
          login: entry.uid.first.force_encoding('utf-8'),
          first_name: entry.givenname.first.force_encoding('utf-8'),
          last_name: entry.sn.first.force_encoding('utf-8'),
          email: entry.mail.first.force_encoding('utf-8'),
          year_entrance: Time.now.year).count).to eq(1)
      end

      it 'download the correct picture' do
        PictureUploader.any_instance.should_receive(:download!).with('http://trombi.tem-tsp.eu/photo.php?uid=logindoesntexist&h=572&w=428').exactly(1).times
        subject.import_one entry
      end
    end
    
    context 'when the person is in db' do
      let(:person) { Fabricate(:person, login: 'login',
                                        profession: 'profession') }

      let(:entry) { double('Entry', uid: [person.login],
                                    givenname: [person.first_name],
                                    sn: [person.last_name],
                                    title: [person.profession],
                                    mail: [person.email]) }

      it 'update this person' do
        subject.should_receive(:update_one).with(person).and_return true
        subject.import_one entry
      end
    end

  end

  describe '#update_people_in_school' do

    before :each do
      Person.stub(:in_school).and_return([person, person])
      subject.stub(:update_one).and_return true
    end

    it 'update each student' do
      subject.should_receive(:update_one).exactly(2).times

      subject.update_people_in_school
    end
  end

  describe '#update_one' do

    before :each do
      subject.ldap.stub(:search).and_return(nil)
      person.stub(:save!)
    end

    it 'save the person' do
      person.should_receive(:save!).once

      subject.update_one person
    end

    context 'year_out attribute' do
      it 'update year_out if it is not in the ldap' do
        subject.ldap.stub(:search).and_return([1])
        person.stub(:year_out).and_return nil

        person.should_receive(:year_out=).with Time.now.year

        subject.update_one person
      end

      it 'do not update year_out if it is in the ldap' do
        person.should_receive(:year_out=).exactly(0).times

        subject.update_one person
      end
    end

    context 'remote_picture_url attribute' do
      it 'add remote url if have no picture' do
        person.stub(:picture?).and_return false
        person.should_receive(:remote_picture_url=).with "http://trombi.tem-tsp.eu/photo.php?uid=#{person.login}&h=572&w=428"

        subject.update_one person
      end
      it 'do not add remote url if already have a picture' do
        person.stub(:picture?).and_return true
        person.should_receive(:remote_picture_url=).exactly(0).times

        subject.update_one person
      end
    end

  end
end
