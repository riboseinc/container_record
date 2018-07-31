# frozen_string_literal: true

class Attachment < ActiveRecord::Base
  include ContainerRecord::DynamicDatabase

  belongs_to :employee
end
