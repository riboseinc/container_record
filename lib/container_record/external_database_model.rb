# frozen_string_literal: true

# This class is used to be replaced whenever a container's model gets accessed
module ContainerRecord
  class ExternalDatabaseModel < ActiveRecord::Base
    # self.establish_connection(ContainerRecord::ConnectionPool.main_db_configuration)
  end
end
