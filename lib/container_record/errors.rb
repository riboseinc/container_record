# frozen_string_literal: true

module ContainerRecord
  class Error < StandardError; end

  class ProcExpected < Error
    def message
      'Expected argument of Proc type'
    end
  end

  class ExternalDatabaseExists < Error
    def message
      'External database model with such name already exists.'
    end
  end
end
