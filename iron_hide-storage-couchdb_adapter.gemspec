# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'iron_hide/storage/couchdb_adapter/version'

Gem::Specification.new do |spec|
  spec.name          = "iron_hide-storage-couchdb_adapter"
  spec.version       = IronHide::Storage::CouchdbAdapter::VERSION
  spec.authors       = ["Alan Cohen"]
  spec.email         = ["acohen@climate.com"]
  spec.summary       = %q{A CouchDB adapter for IronHide Authorization}
  spec.description   = %q{Requires IronHide}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1"
  spec.add_development_dependency "iron_hide"
  spec.add_development_dependency "rake", "~> 10"
  spec.add_development_dependency "rspec", "~> 2.14"
  spec.add_runtime_dependency "typhoeus", "~> 0.6.8"
  spec.add_runtime_dependency "multi_json"
  spec.add_runtime_dependency "couchrest", "~> 1.2"


end
