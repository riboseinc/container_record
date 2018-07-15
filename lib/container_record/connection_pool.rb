# frozen_string_literal: true

module ContainerRecord
  class ConnectionPool
    class << self
      # NOTE TO SELF: Class works.
      # It creates & stores connections to multiple databases
      def create_connection(container)
        connections[container.id] ||= new_connection(container)
      end

      def connection_for(container)
        connections[container.id] ||
          raise("Connection for #{container} not found, try restarting server")
      end

      def connections
        @connections ||= {}
      end

      private

      def new_connection(container)
        # TODO: replace `container.name` with dynamic name generation
        params = main_db_configuration.merge(database: container.name)
        connection_class = Class.new(ActiveRecord::Base)
        # De-anonymize service class,
        # otherwise ActiveRecord denies to establish connection
        # (anonymous class is not allowed)
        Object.const_set(connection_class_name, connection_class)
        connection_class.establish_connection(params)
        connection_class.connection
      end

      def main_db_configuration
        ActiveRecord::Base.configurations[Rails.env].symbolize_keys
      end

      def connection_class_name
        "ContainerRecordClass#{@connections.size + 1}"
      end
    end
  end
end
