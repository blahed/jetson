# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'jetson/version'

Gem::Specification.new do |spec|
  spec.name          = "jetson"
  spec.version       = Jetson::VERSION
  spec.authors       = ["blahed"]
  spec.email         = ["trvsdnn@gmail.com"]

  spec.summary       = "Talk to JSON APIs in a convient ruby based console or use the DSL to make calls in your own code."
  spec.description   = "Jetson provides a simple wrapper for working with JSON APIs – it's built for working with JSON in a friendly and convient way and tries to simplify it to the point of not having to remember complex command line switches or configuration options."
  spec.homepage      = "https://github.com/blahed/jetson"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  
  spec.add_dependency "rest-client", "~> 1.8.0"
  spec.add_dependency "json_color", "~> 0.1.0"

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest"
end
