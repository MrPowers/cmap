# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cmap/version'

Gem::Specification.new do |spec|
  spec.name          = "cmap"
  spec.version       = Cmap::VERSION
  spec.authors       = ["MrPowers"]
  spec.email         = ["matthewkevinpowers@gmail.com"]

  spec.summary       = %q{Converts cmap exports to SQL}
  spec.description   = %q{Converts cmap exports that follow strict conventions into postgreSQL for data analysis}
  spec.homepage      = "https://github.com/MrPowers/cmap"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"

  spec.add_dependency "pg", "0.18.3"
  spec.add_dependency "pry"
  spec.add_dependency "directed_graph", '0.4.0'
end
