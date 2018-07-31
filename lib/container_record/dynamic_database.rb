# frozen_string_literal: true

module ContainerRecord
  module DynamicDatabase
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
    end
  end
end
