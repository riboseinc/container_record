# frozen_string_literal: true

module ContainerRecord
  class Railtie < Rails::Railtie
    initializer 'container_record_railtie.configure_rails_initialization' do
      ::Container.find_each do |container|
        ContainerRecord::ConnectionPool.create_connection(container)
      end
      # TODO: Establish connections
    end
  end
end
