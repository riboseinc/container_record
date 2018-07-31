# frozen_string_literal: true

class Employee < ActiveRecord::Base
  include ContainerRecord::DynamicDatabase

  has_many :attachments
end
