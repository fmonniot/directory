class Api::V1::PeopleController < Api::V1::ApiController
  before_action :set_pagination, only: [:index, :search]

  def index
    respond_with :api, Person.search('*', page: @page, per_page: @per_page)
  end

  def show
    respond_with :api, Person.find(params[:id])
  end

  def search
    @terms = params[:q] || '*'
    @type = (params[:type] == 'i') ? 'i' : 'n'

    if @type == 'i'
      s = Person.search_by_initials @terms, @page, @per_page
    else
      s = Person.search_by_name @terms, @page, @per_page
    end

    response.headers['X-Params'] = @terms + '; ' + @type + '; ' + @page.to_s
    response.headers['Link'] = header_links(s)

    respond_with :api, s
  end

  def destroy
    if params.has_key?(:key)
      confirm_deletion
    else
      mark_to_delete
    end
  end

  private

  def header_links(collection)
    base_link = "<https://trombint.minet.net/api/v1/people?q=#{@terms}&type=#{@type}&page="
    links = []
    
    links << base_link+"1>; rel=\"first\""
    links << base_link+"#{collection.previous_page}>; rel=\"prev\"" unless collection.previous_page.nil?
    links << base_link+"#{collection.next_page}>; rel=\"next\"" unless collection.next_page.nil?
    links << base_link+"#{collection.total_pages}>; rel=\"last\""

    links.join(', ')
  end

  # DELETE api/people/:id
  def mark_to_delete
    person = Person.find person_id_params

    person.generate_key
    PersonMailer.confirm_deletion(person).deliver

    res = {person: PersonSerializer.new(person).as_json(root: false),
           confirmation_url: api_v1_person_url(person)}
    respond_custom res
  end

  # DELETE api/people/:id?key=:key
  def confirm_deletion
    person = Person.find_by person_key_params
    
    person.desindex
    
    respond_with person
  end

  def person_key_params
    params.permit(:key)
  end

  def person_id_params
    params.require(:id)
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_pagination
    @page = params[:page].blank? ? 1 : params[:page].to_i

    @per_page = params[:per_page].blank? ? 25 : params[:per_page].to_i
    @per_page = 100 if @per_page > 100
  end
end
