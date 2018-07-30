# frozen_string_literal: true

DB_CONFIGURATION = {
  adapter: 'sqlite3',
  database: 'spec/db/main.db'
}.freeze

ActiveRecord::Base.establish_connection(DB_CONFIGURATION)

require './spec/support/mocks'

require './spec/support/models/employee'
require './spec/support/models/attachment'
require './spec/support/models/company'

ContainerRecord.configure do |config|
  config.external_database_classes = [Company]
end
