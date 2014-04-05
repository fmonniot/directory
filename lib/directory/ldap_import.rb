class Directory::LdapImport
  attr_accessor :ldap # Delegate this to a LdapGateway class

  def initialize(ldap_config)
    @ldap = Net::LDAP.new host: ldap_config['host'], port: ldap_config['port']
    @attributes_to_import = %w(uid sn givenname mail title objectclass)
    @tree_base = ldap_config['treebase']

    # Used to log information
    @people_saved = 0
    @picture_uploaded = 0
  end

  def filter_uid_ou_present
    filter_uid = Net::LDAP::Filter.present('uid')
    filter_ou = Net::LDAP::Filter.present('ou')

    Net::LDAP::Filter.join(filter_uid, filter_ou)
  end

  def import_all
    #Initialized before import
    @ldap.search(base: @tree_base,
                 attributes: @attributes_to_import,
                 filter: filter_uid_ou_present,
                 return_result: false) do |entry|
      import_one entry
    end
    Rails.logger.info "Saved #{@people_saved} and upload #{@picture_uploaded} pictures."
  end

  def import_one(entry)
    person = Person.find_or_initialize_by(
        login: entry.uid.first.force_encoding('utf-8'),
        first_name: entry.givenname.first.force_encoding('utf-8'),
        last_name: entry.sn.first.force_encoding('utf-8'),
        email: entry.mail.first.force_encoding('utf-8'))

    if person.new_record?
      Rails.logger.info "[#{@people_saved}] Saving #{person.first_name} #{person.last_name} with login #{person.login}"

      person.year_entrance = Time.now.year
      person.profession = entry.title.first.force_encoding('utf-8')
      person.remote_picture_url = "http://trombi.tem-tsp.eu/photo.php?uid=#{person.login}&h=572&w=428"

      person.save!
      @people_saved+=1
    else
      if update_one person
        Rails.logger.info "[#{@picture_uploaded}] Downloaded #{person.login} picture."
        @picture_uploaded+=1
      end
    end
  end

  def update_people_in_school
    Person.in_school.each do |person|
      update_one person
    end
  end

  # update_one
  def update_one(person)

    unless person.year_out
      filter = Net::LDAP::Filter.eq('uid', person.login)
      search_result = ldap.search base: @tree_base, filter: filter
      is_in_ldap = !search_result.nil?

      person.year_out = Time.now.year if is_in_ldap
    end

    unless person.picture?
      person.remote_picture_url = "http://trombi.tem-tsp.eu/photo.php?uid=#{person.login}&h=572&w=428"
    end

    person.save!
  end
end
