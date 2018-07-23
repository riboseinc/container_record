# frozen_string_literal: true

module ContainerRecord
  module ExternalDatabaseModules
    module DynamicClasses
      include Connection

      def has_external(relation_name)
        external_model_class = class_by_relation_name(relation_name)

        # Here we dynamically define classes for every container in the System
        # So every class has its own connection and is able to use ActiveRecord
        # syntax for querying
        define_method(relation_name) do
          self.class.containered_class_for(external_model_class, self).where({})
        end
      end

      # protected

      def containered_class_for(external_model_class, container)
        @containered_classes ||= {}
        @containered_classes[container] ||= {}
        @containered_classes[container][external_model_class] ||=
          define_class_for_container(external_model_class, container)
      end

      private

      def containered_class_name(external_model_class, container)
        [external_model_class, self, container.id].join('_')
      end

      def define_class_for_container(external_model_class, container)
        containered_class = Class.new(external_model_class)
        containered_class_name =
          containered_class_name(external_model_class, container)
        Object.const_set(containered_class_name, containered_class)

        containered_class.establish_connection(ConnectionPool.config_for(container))
        # containered_class.establish_connection(connection_params(container))

        containered_class
      end

      def class_by_relation_name(relation_name)
        relation_name.to_s.capitalize.singularize.constantize
      end
    end
  end
end
