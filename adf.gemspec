# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'adf/version'

Gem::Specification.new do |gem|
  gem.name          = "adf"
  gem.version       = Adf::VERSION
  gem.authors       = ["Andrew Stevens"]
  gem.email         = ["andy@orangesix.com"]
  gem.description   = %q{ADF Parser}
  gem.summary       = %q{Basic parsing of ADF format XML files}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
  gem.add_dependency "builder"
  gem.add_dependency "activesupport"
end
