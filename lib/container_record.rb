# frozen_string_literal: true

require 'container_record/version'
require 'container_record/errors'

require 'container_record/configuration'

require 'container_record/external_database_modules/connection'
require 'container_record/external_database_modules/dynamic_classes'
require 'container_record/external_database'

require 'container_record/dynamic_database'

module ContainerRecord
  extend Configuration
end
