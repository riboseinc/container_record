# frozen_string_literal: true

module ContainerRecord
  class ExternalDatabase < ActiveRecord::Base
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

    # TODO: Remove me, just for proof of concept
    def files
      # Where to get connections?
      # ActiveRecord::Base.establish_connection(config)
      # ConnectionPool.connection_for(self)
      ConnectionPool.connection_for(self.id)
        .execute('select * from files')
        .map { |tuple| File.new(tuple) }
    end

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

=begin

  # config/initializers/container_record.rb:

  ContainerRecord.configure do
    # This is going to be used if corresponding columns
    # in `external_databases` table are NULL
    default_connection 'config/database.yml'
    # or
    default_connection(adapter: 'sqlite3', host: 'localhost', ...)
  end

  # In gem:
  # Read all records in `external_databases` table,
  # create a connection pull for each of them

  # app/models/container.rb

  # Do we need this?
  # Yes - for explicity
  # No  - for all the same behaviour
  class ExternalDatabase < ContainerRecord::ExternalDatabase
  end

  class User < ApplicationRecord
    has_many :external_databases
    has_many :addresses
  end

  # ContainerRecord::ExternalDatabase::Remote means we should:
  #   1. Lookup for a user's external_database
  #   2. Lookup for a table called `addresses` (or specified by `self.table_name`)
  #      in this external table
  #   3. Lookup for records according to filters
  #
  #   So, user.
  class Address < ContainerRecord::ExternalDatabase::Remote
    belongs_to :user
  end
=end
