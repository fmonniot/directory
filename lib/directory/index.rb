class Directory::Index

  def initialize(*models)
    @models = models
  end

  def recreate
    @models.each { |model| model.recreate_search_index }
  end

  def populate
    @models.each do |model|
      model.indexable.import_all
      Tire.index(model.index_name).refresh
    end
  end
end