json.array!(@people) do |person|
  json.extract! person,
  json.url admin_person_url(person, format: :json)
end
