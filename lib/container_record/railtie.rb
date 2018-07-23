# frozen_string_literal: true

module ContainerRecord
  class Railtie < Rails::Railtie
    initializer 'container_record_railtie.configure_rails_initialization' do
      # TODO: Make sure we establish connection on server loading
      # To avoid multiple connections opening while server is working
      ::Container.find_each do |subclass_record|
        ContainerRecord::ConnectionPool.create_connection(subclass_record)
      end
      # ContainerRecord::ExternalDatabase.subclasses.each do |subclass|
      #   subclass.find_each do |subclass_record|
      #     ContainerRecord::ConnectionPool.create_connection(subclass_record)
      #   end
      # end
    end
  end
end
