# frozen_string_literal: true

module ContainerRecord
  class Error < StandardError; end

  class ProcExpected < Error
    def message
      'Expected argument of Proc type'
    end
  end
end
