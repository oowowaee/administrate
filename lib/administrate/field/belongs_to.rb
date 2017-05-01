require_relative "associative"

module Administrate
  module Field
    class BelongsTo < Associative
      def self.permitted_attribute(attr)
        :"#{attr}_id"
      end

      def permitted_attribute
        self.class.permitted_attribute(attribute)
      end

      def associated_resource_options
        [nil] + candidate_resources.map do |resource|
          [display_candidate_resource(resource), resource.send(primary_key)]
        end
      end

      def selected_option
        data && data.send(primary_key)
      end

      private

      def candidate_resources
        return associated_class.order("#{order} #{direction}") unless order.nil?
        associated_class.all
      end

      def display_candidate_resource(resource)
        associated_dashboard.display_resource(resource)
      end

      def order
        options[:order]
      end

      def direction
        options[:direction] || 'ASC'
      end
    end
  end
end
