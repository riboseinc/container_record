# frozen_string_literal: true

module ContainerRecord
  module ExternalDatabaseModules
    module Connection

      # MySQL set of options for database.yml (TODO: add PG)
      CONFIG_OPTIONS = %i[
        username password database adapter encoding pool host port socket
        reconnect strict variables
        sslca sslkey sslcert sslcapath sslcipher
      ]

      private

      # TODO: Add support for custom database name (lambda?)
      def connection_params(container)
        config = container_connection_config(container)
        main_db_configuration.merge(config)
      end

      def container_connection_config(container)
        container.attributes.slice(*CONFIG_OPTIONS)
      end

      # Just for default purposes
      # since everything can be overwritten by containers
      def main_db_configuration
        ::ActiveRecord::Base.configurations[Rails.env].symbolize_keys
      end
    end
  end
end
