# frozen_string_literal: true

require 'pry'

require 'container_record/config'
require 'container_record/railtie'
require 'container_record/connection_pool'

require 'container_record/external_database_modules/connection'
require 'container_record/external_database_modules/dynamic_classes'
require 'container_record/external_database'

require 'container_record/version'

# TODO: OnLoad - create connection pools
