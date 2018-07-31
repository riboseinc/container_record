# frozen_string_literal: true

module ContainerRecord
  module Configuration
    def configure
      yield config
      setup_classes!
    end

    private

    def config
      @config ||= OpenStruct.new(defaults)
    end

    def defaults
      { external_database_classes: [] }
    end

    def setup_classes!
      config.external_database_classes.each(&:define_external_relations!)
    end
  end
end
