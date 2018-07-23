# frozen_string_literal: true

module ContainerRecord
  class ExternalDatabase < ActiveRecord::Base
    extend ContainerRecord::ExternalDatabaseModules::DynamicClasses

    # TODO: Establish connection, save connection pool
    # ==========================================================================
    # Mandatory: to have `external_databases` table in a main database
    # Required fields:
    #   adapter
    #   encoding
    #   host
    #   port
    #   pool
    #   name
    #   username
    #   password (TODO: encrypted?)
    #   ... any other fields needed for business ...
    after_create :setup_connection

    private

    def setup_connection
      create_connection
      create_database_if_missing
    end

    def create_connection
      # TODO: Force container record to be re-initialized OR
      #       Just add a connection pull to existing list of pulls
      # To be implemented: later
      # For now: you need to restart server to catch up those settings
    end

    def create_database_if_missing
      # Check if external database exists
      # If not - create database
    end
  end
end
