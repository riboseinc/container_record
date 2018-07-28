# frozen_string_literal: true

module ContainerRecord
  class ExternalDatabase < ::ActiveRecord::Base
    extend ContainerRecord::ExternalDatabaseModules::DynamicClasses

    self.abstract_class = true

    # TODO: Fix the case when database_name is called after has_external
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

    class << self
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
