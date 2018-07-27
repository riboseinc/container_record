# frozen_string_literal: true

module ContainerRecord
  class DynamicDatabase < ::ActiveRecord::Base
    self.abstract_class = true
    # Connection is going to be overwritten every time
    # self.establish_connection({})
  end
end
