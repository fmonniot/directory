require 'spec_helper'
 
describe PersonMailer do
  let(:person) { Fabricate(:person) }
  let(:mail) { PersonMailer.confirm_deletion(person) }

  describe 'general confirmation' do
 
    #ensure that the receiver is correct
    it 'renders the receiver email' do
      mail.to.should == [person.email]
    end
 
    #ensure that the sender is correct
    it 'renders the sender email' do
      mail.from.should == ['trombint@minet.net']
    end
 
    #ensure that the @name variable appears in the email body
    it 'assigns names' do
      mail.body.encoded.should match(person.first_name)
      mail.body.encoded.should match(person.last_name)
    end
 
    #ensure that the @confirmation_url variable appears in the email body
    it 'assigns @confirmation_url' do
      mail.body.encoded.should match('http://localhost:3000/people/confirm_deletion')
    end

  end

  describe 'delete confirmation' do
 
    #ensure that the subject is correct
    it 'renders the subject' do
      mail.subject.should == '[Tromb\'INT MiNET] Deletion procedure'
    end

  end
end