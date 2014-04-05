Fabricator(:person) do
  first_name 'William'
  last_name 'Dalton'
  email 'william.dalton@texas.us'
  year_entrance Time.now.year
end
