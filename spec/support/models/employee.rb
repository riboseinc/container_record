# frozen_string_literal: true

class Employee < ContainerRecord::DynamicDatabase
  has_many :attachments
end
