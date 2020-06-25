# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'finapps_core/version'
Gem::Specification.new do |spec|
  spec.name = 'finapps_core'
  spec.version = FinAppsCore::VERSION
  spec.platform = Gem::Platform::RUBY
  spec.authors = ['Erich Quintero']
  spec.email = ['erich@financialapps.com']

  spec.summary = 'FinApps REST API ruby client - Core.'
  spec.description = 'A simple library for communicating with the FinApps REST API. Core functionality.'
  spec.homepage = 'https://github.com/finapps/ruby-client-core'
  spec.licenses = ['MIT']

  spec.files = `git ls-files -z`.split("\x0")
  spec.executables = spec.files.grep(%r{^bin/}) {|f| File.basename(f) }
  spec.test_files = Dir['spec/**/*.rb']
  spec.require_paths = ['lib']

  spec.add_runtime_dependency     'faraday',                    '~> 1.0',   '>= 1.0.1'
  spec.add_runtime_dependency     'faraday_middleware',         '~> 1.0',   '>= 1.0'

  spec.add_development_dependency 'bundler',                    '~> 2.0',   '>= 2.0.2'
  spec.add_development_dependency 'codeclimate-test-reporter',  '~> 1.0',   '>= 1.0.9'
  spec.add_development_dependency 'gem-release',                '~> 2.0',   '>= 2.0.3'
  spec.add_development_dependency 'rake',                       '~> 13.0',  '>= 13.0.1'
  spec.add_development_dependency 'rspec',                      '~> 3.8',   '>= 3.8.0'
  spec.add_development_dependency 'rubocop',                    '~> 0.86',  '>= 0.86.0'
  spec.add_development_dependency 'rubocop-performance',        '~> 1.6',   '>= 1.6.1'
  spec.add_development_dependency 'rubocop-rspec',              '~> 1.40',  '>= 1.40.0'
  spec.add_development_dependency 'sinatra',                    '~> 2.0',   '>= 2.0.5'
  spec.add_development_dependency 'webmock',                    '~> 3.6',   '>= 3.6.0'

  spec.extra_rdoc_files = %w(README.md LICENSE)
  spec.rdoc_options = %w(--line-numbers --inline-source --title finapps-ruby-core --main README.md)
end
