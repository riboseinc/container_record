# frozen_string_literal: true

module ContainerRecord
  module ExternalDatabaseModules
    module DynamicClasses
      include Connection

      RAILS_ASSOCIATION_PARAMS = %i[foreign_key].freeze

      def external_relations
        @external_relations ||= {}
      end

      # rubocop:disable Naming/PredicateName
      def has_external(relation_name)
        klass = class_by_relation_name(relation_name)
        external_relations[relation_name] = klass
      end
      # rubocop:enable Naming/PredicateName

      def define_external_relations!
        external_relations.each do |relation_name, external_model_class|
          # Here we dynamically define classes for every container in the System
          # So every class has its own connection
          # and is able to use ActiveRecord syntax for querying
          define_dynamic_classes!(external_model_class)

          define_method(relation_name) do
            self.class
                .containered_class_for(external_model_class, self)
                .where({})
          end
        end
      end

      def containered_class_for(external_model_class, container)
        @containered_classes ||= {}
        @containered_classes[container] ||= {}
        @containered_classes[container][external_model_class] ||=
          define_class_for_container(external_model_class, container)
      end

      private

      def define_dynamic_classes!(external_model_class)
        find_each do |external_database_record|
          containered_class_for(external_model_class, external_database_record)
        end
      end

      def containered_class_name(container)
        [self, container.id].join
      end

      def define_class_for_container(external_model_class, container)
        containered_class = Class.new(external_model_class)
        class_name        = containered_class_name(container)

        external_model_class.const_set(class_name, containered_class)
        containered_class.establish_connection(connection_params(container))

        redefine_associations!(containered_class, class_name)

        containered_class
      end

      def class_by_relation_name(relation_name)
        relation_name.to_s.capitalize.singularize.camelize.constantize
      end

      def redefine_associations!(containered_class, class_name)
        reflections = containered_class.reflect_on_all_associations
        reflections.each do |reflection|
          options = reflection_options_copy(reflection)
          containered_class.instance_eval do
            send(
              reflection.macro,
              reflection.name,
              options.merge(
                class_name: [reflection.klass, class_name].join('::')
              )
            )
          end
        end
      end

      def reflection_options_copy(reflection)
        RAILS_ASSOCIATION_PARAMS.each_with_object({}) do |key, copy|
          copy[key] = reflection.public_send(key)
        end.merge(reflection.options)
      end
    end
  end
end
