# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'expedition/version'

Gem::Specification.new do |spec|
  spec.name          = 'expedition'
  spec.version       = Expedition::VERSION
  spec.authors       = ['Gabe Evans']
  spec.email         = ['gabe@ga.be']
  spec.summary       = %q{Expedition is an implementation of the cgminer client protocol. It allows you to write programs that interact with cgminer and cgminer-compatible software.}
  spec.description   = spec.summary
  spec.homepage      = 'https://github.com/gevans/expedition'
  spec.license       = 'MIT'

  spec.required_ruby_version = '>= 2.0.0'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = %w(lib)

  spec.add_dependency 'multi_json',    '~> 1.3'
  spec.add_dependency 'activesupport', '>= 3.2'

  spec.add_development_dependency 'bundler', '~> 1.5'
  spec.add_development_dependency 'coveralls'
  spec.add_development_dependency 'guard'
  spec.add_development_dependency 'guard-bundler'
  spec.add_development_dependency 'guard-rspec'
  spec.add_development_dependency 'guard-yard'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rb-fsevent'
  spec.add_development_dependency 'rb-inotify'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'terminal-notifier-guard'
  spec.add_development_dependency 'yard'
end
