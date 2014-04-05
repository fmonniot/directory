class Person
  include Mongoid::Document
  include Mongoid::Timestamps
  include Indexable

  field :f , as: :first_name, type: String
  field :l,  as: :last_name, type: String
  field :p,  as: :profession, type: String
  field :e,  as: :email, type: String
  field :log, as: :login, type: String
  field :y,  as: :year_entrance, type: Integer
  field :yo, as: :year_out, type: Integer

  field :i,  as: :indexable, type: Boolean, default: true
  field :k,  as: :key, type: String

  mount_uploader :picture, PictureUploader

  scope :indexable, ->{ where(indexable: true) }
  scope :in_school, ->{ where(:year_out.exists => true) }
  scope :with_profession, ->(profession){ self.where(p: /^#{profession}$/i) if profession.present? }

  def picture_src
    Digest::SHA1.hexdigest("#{first_name}#{last_name}#{year_entrance}")
  end

  def initials
    initial = ''

    return '' if first_name.nil? && last_name.nil?

    [first_name, last_name].each do |c|
      initial << c[0]
    end

    initial.upcase
  end

  def full_name
    [first_name, last_name].join ' '
  end

  def generate_key
    update_attribute(:key, Digest::SHA1.hexdigest("#{first_name}#{last_name}#{Time.now}"))
  end

  def desindex
    update_attribute(:indexable, false)
    update_attribute(:key, nil)
    Person.tire.index.remove self
  end

  def to_indexed_json
    {
      login: login,
      first_name: first_name,
      last_name: last_name,
      profession: profession,
      email: email,
      year_entrance: year_entrance,
      year_out: year_out,
      picture_src: picture_src,
      initials: initials
    }.to_json
  end

  class << self

    def search_by_name(terms, page = 0, per_page = 25)
      Person.tire.search per_page: per_page, page: page do
        query do
          boolean do
            should { match 'last_name', terms, {boost: 3} }
            should { match 'last_name.partial', terms }
            should { match 'first_name', terms, {boost: 1} }
            should { match 'first_name.partial', terms }
          end
        end
      end
    end

    def search_by_initials(terms, page = 0, per_page = 25)
      terms = terms.gsub(/(\.| |\-)+/, '')
      Person.tire.search per_page: per_page, page: page do
        query do
          boolean do
            should { match 'initials', terms }
          end
        end
      end
    end

    def facet_profession

      s = self.tire.search  do
        size 0 # Retrieve only the facet
        facet('profession') { terms :profession, size: 40 }
      end

      s.facets['profession'].delete('_type')
      s.facets['profession']
    end

    # Create the index with proper settings/mappings
    # Override concerns/indexable
    def create_search_index
      Tire.index Person.index_name do
        create(
          settings: {
            analysis: {
              filter: {
                name_ngrams: {
                    'side' => 'front',
                    'max_gram' => 10,
                    'min_gram' => 1,
                    'type' => 'edgeNGram'
                }
              },
              analyzer: {
                full_name: {
                    'filter' => %w(standard lowercase asciifolding),
                    'type' => 'custom',
                    'tokenizer' => 'standard'
                },
                partial_name: {
                    'filter' => %w(standard lowercase asciifolding name_ngrams),
                    'type' => 'custom',
                    'tokenizer' => 'standard'
                },
                keyword: {
                    'filter' => %w(lowercase),
                    'tokenizer' => 'keyword'
                }
              }
            },
            store: {
              type: Rails.env.test? ? :memory : :niofs
            }
          },
          mappings: {
            person: {
              properties: {
                first_name: {
                   fields: {
                      partial: {
                         search_analyzer: 'full_name',
                         index_analyzer: 'partial_name',
                         type: 'string'
                      },
                      first_name: {
                         type: 'string',
                         analyzer: 'full_name'
                      }
                   },
                   type: 'multi_field'
                },
                last_name: {
                   fields: {
                      partial: {
                         search_analyzer: 'full_name',
                         index_analyzer: 'partial_name',
                         type: 'string'
                      },
                      last_name: {
                         type: 'string',
                         analyzer: 'full_name'
                      }
                   },
                   type: 'multi_field'
                },
                initials: {
                  type: 'string',
                  analyzer: 'simple'
                },
                profession: {
                   type: 'string',
                   analyzer: 'keyword'
                },
                email: {
                   type: 'string',
                   analyzer: 'simple'
                },
                login: {
                   type: 'string',
                   analyzer: 'simple'
                },
                year_entrance: {
                   type: 'date',
                   format: 'YYYY'
                },
                year_out: {
                   type: 'date',
                   format: 'YYYY'
                }
              }
            }
          }
        )
      end
    end

  end
end
