lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "rack/anchor/version"

Gem::Specification.new do |spec|
  spec.name          = "rack-anchor"
  spec.version       = Rack::Anchor::VERSION
  spec.authors       = ["Joshua Frankel"]
  spec.email         = ["joshmfrankel@gmail.com"]

  spec.summary       = "Keeps your shelf from falling over"
  spec.description   = "Keeps your shelf from falling over"
  spec.homepage      = "https://github.com/joshmfrankel/rack-anchor"

  spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/joshmfrankel/rack-anchor"
  spec.metadata["changelog_uri"] = "https://github.com/joshmfrankel/rack-anchor/blob/master/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rack", "~> 2.0"
  spec.add_development_dependency "rack-test", "~> 1.1"
  spec.add_development_dependency "sinatra", "~> 2.0"
  spec.add_development_dependency "sinatra-contrib", "~> 2.0"
  spec.add_development_dependency "pry", "~> 0.12"
end
