class Visit
  include Mongoid::Document
  include Mongoid::Timestamps
  include Indexable

  field :session_id, type: String
  field :method, type: String
  field :url, type: String
  field :ip, type: String
  field :params, type: Hash
  field :http_headers, type: Hash

  mapping do
    indexes :id,           index: :not_analyzed
    indexes :created_at,   type:  'date'
  end

  scope :indexable, -> { all }

  class << self

    def facet_date(options = {})

      s = self.tire.search  do
        size 0 # Retrieve only the facet
        facet('timeline') { date :created_at, interval: options[:interval] || 'day' }
      end

      s.facets['timeline'].delete('_type')
      s.facets['timeline']
    end

  end
end
