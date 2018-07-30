# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'container_record/version'

Gem::Specification.new do |spec|
  spec.name          = 'container_record'
  spec.version       = ContainerRecord::VERSION
  spec.authors       = ['Ribose Inc.']
  spec.email         = ['open.source@ribose.com']

  spec.summary       = 'Use multiple database connections in your Rails project'
  spec.homepage      = 'https://github.com/riboseinc/container_record'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end

  spec.required_ruby_version = '>= 2.3.0'

  spec.require_paths = ['lib']

  spec.add_dependency 'activerecord', '~> 5.0'

  spec.add_development_dependency 'bundler', '~> 1.13'
  spec.add_development_dependency 'ffaker', '~> 2'
  spec.add_development_dependency 'pry', '~> 0.10.0'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'simplecov', '~> 0.15.0'
  spec.add_development_dependency 'sqlite3', '~> 1.3'
end
