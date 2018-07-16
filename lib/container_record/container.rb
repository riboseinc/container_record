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
        # binding.pry
        # define_method(class_to_many_relation(external_relation)) do
        #   # TODO: Replace with real query from AR chain
        #   query = "select * from #{external_relation.table_name}"
        #   self.containers.map do |container|
        #     container.execute(query).map do |tuple|
        #       external_relation.new(tuple)
        #     end
        #   end
        # end
      end
    end

    module ClassMethods
      # def has_many_in_containers(relation_name, options)
      #   has_many relation_name, **options
      # end

      def has_many_external(relation_name, strored_in:)
        external_relation_klass = add_external_has_many_relation!(relation_name)

        define_method(relation_name) do
          if strored_in == self.class
            self.class.execute_query(self, external_relation_klass)
          else
            containers_relation_method = strored_in.to_s.underscore.pluralize
            # TODO: Return Proxy object to be able to filter files by some criteria
            self.public_send(containers_relation_method).map do |container|
              self.class.execute_query(container, external_relation_klass)
            end.flatten
          end
        end
      end

      def execute_query(container, external_relation_klass)
        connection = ConnectionPool.connection_for(container)
        table_name = make_table_name(external_relation_klass)
        query = "select * from #{table_name}"
        connection.execute(query).map do |tuple|
          external_relation_klass.new(tuple)
        end
      end

      def container_record(container_class)
        return @container_class = container_class unless @container_class

        raise('Multiple containers at the same time are unsupported')
      end

      def external_has_many_relations
        @external_has_many_relations ||= []
      end

      private

      def make_table_name(external_relation)
        external_relation.to_s.split('::').last.underscore.pluralize
      end

      def add_external_has_many_relation!(relation_name)
        external_relation =
          relation_name.to_s.capitalize.singularize.constantize
        @external_has_many_relations << external_relation
        external_relation
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
