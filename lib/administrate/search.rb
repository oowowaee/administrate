require "active_support/core_ext/module/delegation"
require "active_support/core_ext/object/blank"

module Administrate
  class Search
    def initialize(resolver, term)
      @resolver = resolver
      @term = term
    end

    def run
      if @term.blank?
        resource_class.all
      else
        resource_class.where(query, *search_terms)
      end
    end

    private

    delegate :resource_class, to: :resolver

    def query
      search_attributes.map do |attr|
        table_name = ActiveRecord::Base.connection.
          quote_table_name(resource_class.table_name)
        attr_name = ActiveRecord::Base.connection.quote_column_name(attr)
        "lower(#{table_name}.#{attr_name}) LIKE ?"
      end.join(" OR ")
    end

    def search_terms
      ["%#{term.downcase}%"] * search_attributes.count
    end

    def search_attributes
      attribute_types.keys.select do |attribute|
        attribute_types[attribute].searchable?
      end
    end

    def attribute_types
      resolver.dashboard_class::ATTRIBUTE_TYPES
    end

    attr_reader :resolver, :term
  end
end
