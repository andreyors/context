# frozen_string_literal: true

lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "context/version"

Gem::Specification.new do |gem|
  gem.name          = "context"
  gem.version       = Context::VERSION
  gem.authors       = ["Andrey Orsoev"]
  gem.email         = ["andrey.orsoev@gmail.com"]
  gem.summary       = "Context gives you a per-thread global storage"
  gem.description   = "Context gives you a per-thread global storage"
  gem.homepage      = "http://github.com/andreyors/context"
  gem.licenses      = ["MIT"]

  gem.require_paths = ["lib"]
  gem.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end

  gem.add_dependency "rack", "~> 2.0"

  gem.add_development_dependency "bundler", "~> 1.16"
  gem.add_development_dependency "pry", "~> 0.10"
  gem.add_development_dependency "rake", "~> 13.0"
  gem.add_development_dependency "rspec", "~> 3.0"
  gem.add_development_dependency "rubocop"
  gem.add_development_dependency "rubocop-rspec", "~> 1.30"
end