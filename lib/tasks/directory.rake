Dir.glob('lib/directory/*.rb').each { |r| load r}

namespace :directory do

  desc 'Create index (and destroy current index if any)'
  task create_index: :environment do
    Directory::Index.new(Person).recreate
  end

  desc 'Populate elasticsearch index with database entries (and destroy current index if any)'
  task populate: :environment do
    Directory::Index.new(Person, Visit).populate
  end

  desc 'Import people from LDAP in database'
  task import_all: :environment do
    importer = Directory::LdapImport.new YAML.load_file("#{Rails.root}/config/ldap.yml")['disi']
    importer.import_all
  end

  desc 'Verify for each person without year_out if he is currently in the ldap'
  task update_people_in_school: :environment do
    importer = Directory::LdapImport.new YAML.load_file("#{Rails.root}/config/ldap.yml")['disi']
    importer.update_people_in_school
  end

end