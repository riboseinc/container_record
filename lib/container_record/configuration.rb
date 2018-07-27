# frozen_string_literal: true

module ContainerRecord
  module Configuration
    class << self
      def configure
        yield config
      end

      private

      def config
        @config ||= OpenStruct.new
      end
    end
  end
end
