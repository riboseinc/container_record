# frozen_string_literal: true

module ContainerRecord
  module Container
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      # def has_many_in_containers(relation_name, options)
      #   has_many relation_name, **options
      # end

      def containers_has_many(relation_name, options)
        # TODO:
        # 1. get containers
        # 2. get files from every container
        # 3. merge arrays into one array
        Container.where(user_id: self.id).each do |container|
          container.files
        end.flatten
        # Idea: To return PseudoClasses named by container name
        # i.e. Instead of File -> File::Main, File::Backup, File::Whatever
        # meaning those files came from containers with names `name`, `backup`,
        # or `whatever` accordingly
      end

      def container_record(container_class)
        return @container_class = container_class unless @container_class

        raise('Multiple containers at the same time are unsupported')
      end
    end
    # TODO:
    # Implement the following usage:
    # 1. User.find(2).containers.files
    # 2. To return array of files from multiple databases (for every container):
    #   File<> # < ActiveRecord::Base
    #   File<>
    #   File<>
  end
end
