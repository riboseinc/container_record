# frozen_string_literal: true

module Mocks
  def main_db_configuration
    { adapter: 'sqlite3', database: 'main' }
  end
end
