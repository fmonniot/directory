class PersonSerializer < ActiveModel::Serializer
  attributes :id, :first_name, :last_name, :profession,
             :email, :year_entrance, :year_out, :picture_src

  def id
    "#{object.id}"
  end
end