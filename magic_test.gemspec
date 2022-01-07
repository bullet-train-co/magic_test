lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "magic_test/version"

Gem::Specification.new do |spec|
  spec.name = "magic_test"
  spec.version = MagicTest::VERSION
  spec.authors = ["Andrew Culver", "Adam Pallozzi"]
  spec.email = ["andrew.culver@gmail.com", "adampallozzi@gmail.com"]

  spec.summary = "Create system tests interactively."
  spec.homepage = "https://github.com/bullet-train-co/magic_test"
  spec.license = "MIT"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path("..", __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", ">= 2.0"
  spec.add_development_dependency "rake", ">= 13.0"
  spec.add_development_dependency "minitest", ">= 5.0"
  spec.add_development_dependency "standard"

  spec.add_dependency "pry"
  spec.add_dependency "pry-stack_explorer"
  spec.add_dependency "capybara", ">= 3.0"
  spec.add_dependency "rails", ">= 6.0"
end
