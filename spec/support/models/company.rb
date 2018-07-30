# frozen_string_literal: true

class Company < ContainerRecord::ExternalDatabase
  extend Mocks

  has_external :employees
  has_external :attachments
  database_name ->(company) { "spec/db/#{company.name.downcase}_database.db" }
end
