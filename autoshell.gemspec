# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'autoshell/version'

Gem::Specification.new do |spec|
  spec.name          = 'autoshell'
  spec.version       = Autoshell::VERSION
  spec.authors       = ['Ryan Mark']
  spec.email         = ['ryan@mrk.cc']

  spec.summary       = 'Library for automating shell tasks in Autotune'
  spec.description   = ''
  spec.homepage      = 'http://github.com/ryanmark/autoshell'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`
    .split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'mime-types', '>= 2.6'
  spec.add_runtime_dependency 'ansi', '~> 1.5'

  spec.add_development_dependency 'bundler', '~> 1.10'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'yard'
  spec.add_development_dependency 'minitest'
  spec.add_development_dependency 'pry'
end
