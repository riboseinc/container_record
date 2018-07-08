# frozen_string_literal: true

module ContainerRecord
  class ConnectionPool
    class << self
      attr_reader :connections

      def create_connection(container)
        @connections ||= []
        @connections[container.id] ||= new_connection(container)
      end

      def connection_for(container)
        @connections[container.id] ||
          raise("Connection for #{container} not found, try restarting server")
      end

      private

      def new_connection(container)
        # TODO: replace `container.name` with dynamic name generation
        params = main_db_configuration.merge(database: container.name)
        connection_class =
          Class.new(ActiveRecord::Base) do
            establish_connection(params)
          end
        connection_class.connection
      end

      def main_db_configuration
        ActiveRecord::Base.configurations[Rails.env].symbolize_keys
      end
    end
  end
end
