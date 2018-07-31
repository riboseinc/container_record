# frozen_string_literal: true

module ContainerRecord
  class Registry
    class << self
      attr_reader :external_database_classes

      def register_external_database!(klass)
        if external_database_classes.include?(klass)
          raise ExternalDatabaseExists
        end

        @external_database_classes << klass
      end
    end
  end
end
