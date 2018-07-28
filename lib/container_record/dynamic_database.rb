# frozen_string_literal: true

module ContainerRecord
  class DynamicDatabase < ::ActiveRecord::Base
    self.abstract_class = true
  end
end
