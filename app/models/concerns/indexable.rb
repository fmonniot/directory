# app/models/concerns/taggable.rb
# notice that the file name has to match the module name
# (applying Rails conventions for autoloading)
module Indexable
  extend ActiveSupport::Concern

  included do |base|
    include Tire::Model::Search
    include Tire::Model::Callbacks

    index_name "#{Tire::Model::Search.index_prefix}#{base.to_s.pluralize.downcase}"
  end

  module ClassMethods
    def search_index
      Tire.index(self.index_name)
    end
    # Create the index with proper settings/mappings
    def create_search_index
      Tire.index self.index_name
    end

    def delete_search_index
      search_index.delete
    end

    def recreate_search_index
      delete_search_index
      create_search_index
    end
  end
end