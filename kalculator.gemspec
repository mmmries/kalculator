lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "kalculator/version"

Gem::Specification.new do |spec|
  spec.name          = "kalculator"
  spec.version       = Kalculator::VERSION
  spec.authors       = ["Michael Ries"]
  spec.email         = ["michael@riesd.com"]

  spec.summary       = "A calculator that can safely and quickly interpret user-input"
  spec.description   = spec.summary
  spec.homepage      = "https://github.com/mmmries/kalculator"
  spec.license       = "MIT"

  spec.files         = ["kalculator.gemspec"] + Dir["lib/**/*"]
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "rltk", "~> 3.0"

  spec.add_development_dependency "benchmark-ips", "~> 2.7"
  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
