# frozen_string_literal: true

class Attachment < ContainerRecord::DynamicDatabase
  belongs_to :employee
end
