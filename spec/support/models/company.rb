# frozen_string_literal: true

class Company < ContainerRecord::ExternalDatabase
  extend Stubs

  database_name ->(company) { "spec/db/#{company.name.downcase}_database.db" }
  has_external :employees
  has_external :attachments
end
