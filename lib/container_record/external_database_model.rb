# frozen_string_literal: true

# This class is used to be replaced whenever a container's model gets accessed
module ContainerRecord
  class ExternalDatabaseModel
    include ActiveModel::Model
  end
end
