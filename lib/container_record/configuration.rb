# frozen_string_literal: true

module ContainerRecord
  module Configuration
    def configure
      yield config
    end

    private

    def config
      @config ||= OpenStruct.new(defaults)
    end

    def defaults
      { external_database_classes: [] }
    end
  end
end
