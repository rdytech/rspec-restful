# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rspec_restful/version'

Gem::Specification.new do |spec|
  spec.name          = "rspec_restful"
  spec.version       = RspecRestful::VERSION
  spec.authors       = ["Jason Langenauer"]
  spec.email         = ["jasonl@jobready.com.au"]

  spec.summary       = %q{RSpec helpers to easily test RESTful controllers}
  spec.description   = %q{RSpec helpers to easily test RESTful controllers}
  spec.homepage      = "https://github.com/jobready/rspec-restful"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.9"
  spec.add_development_dependency "rake", "~> 10.0"
end
