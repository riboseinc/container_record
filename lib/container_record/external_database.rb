# frozen_string_literal: true

module ContainerRecord
  module ExternalDatabase
    def self.included(base)
      base.extend ClassMethods
      base.extend ContainerRecord::ExternalDatabaseModules::DynamicClasses
      base.include InstanceMethods
    end

    module InstanceMethods
      def database_name
        database_name_proc = self.class.options[:database_name]
        return database_name_proc.call(self) if database_name_proc

        database
      end

      def create_external_record(model_class, params = nil)
        self.class.containered_class_for(model_class, self).create(params)
      end

      def create_external_record!(model_class, params = nil)
        self.class.containered_class_for(model_class, self).create!(params)
      end
    end

    module ClassMethods
      def options
        { database_name: @database_name }
      end

      private

      def database_name(callback)
        return @database_name = callback if callback.is_a?(Proc)

        raise ProcExpected
      end
    end
  end
end
