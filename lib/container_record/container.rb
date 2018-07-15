# frozen_string_literal: true

module ContainerRecord
  module Container
    def self.included(base)
      base.extend(ClassMethods)
      base.external_has_many_relations.each do |external_relation|
        # Idea: To return PseudoClasses named by container name
        # i.e. Instead of File -> File::Main, File::Backup, File::Whatever
        # meaning those files came from containers with names `name`, `backup`,
        # or `whatever` accordingly
        define_method(class_to_many_relation(external_relation)) do
          # TODO: Replace with real query from AR chain
          query = "select * from #{external_relation.table_name}"
          self.containers.map do |container|
            container.execute(query).map do |tuple|
              external_relation.new(tuple)
            end
          end
        end
      end
    end

    module ClassMethods
      # def has_many_in_containers(relation_name, options)
      #   has_many relation_name, **options
      # end

      def containers_has_many(relation_name, options = {})
        add_external_has_many_relation!(relation_name)
        # TODO:
        # 1. get containers
        # 2. get files from every container
        # 3. merge arrays into one array

        # Container.where(user_id: self.id).each do |container|
        #   container.files
        # end.flatten
      end

      def container_record(container_class)
        return @container_class = container_class unless @container_class

        raise('Multiple containers at the same time are unsupported')
      end

      def external_has_many_relations
        @external_has_many_relations ||= []
      end

      private

      # TODO: Find existing method in AR for that
      def class_to_many_relation(klass)
        external_relation.to_s.split('::').last.underscore
      end

      def add_external_has_many_relation!(relation_name)
        @external_has_many_relations <<
          relation_name.to_s.capitalize.singularize.constantize
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
