require 'spec_helper'
 
describe PersonMailer, :type => :mailer do
  let(:person) { Fabricate(:person) }
  let(:mail) { PersonMailer.confirm_deletion(person) }

  describe 'general confirmation' do
 
    #ensure that the receiver is correct
    it 'renders the receiver email' do
      expect(mail.to).to eq([person.email])
    end
 
    #ensure that the sender is correct
    it 'renders the sender email' do
      expect(mail.from).to eq(['trombint@minet.net'])
    end
 
    #ensure that the @name variable appears in the email body
    it 'assigns names' do
      expect(mail.body.encoded).to match(person.first_name)
      expect(mail.body.encoded).to match(person.last_name)
    end
 
    #ensure that the @confirmation_url variable appears in the email body
    it 'assigns @confirmation_url' do
      expect(mail.body.encoded).to match('http://localhost:3000/people/confirm_deletion')
    end

  end

  describe 'delete confirmation' do
 
    #ensure that the subject is correct
    it 'renders the subject' do
      expect(mail.subject).to eq('[Tromb\'INT MiNET] Deletion procedure')
    end

  end
end