class PersonMailer < ActionMailer::Base
  default from: 'trombint@minet.net'

  def confirm_deletion(person)
    @person = person
    mail(to: @person.email, subject: '[Tromb\'INT MiNET] Deletion procedure')
  end
end
