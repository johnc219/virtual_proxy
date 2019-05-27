
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "virtual_proxy/version"

Gem::Specification.new do |spec|
  spec.name          = "virtual_proxy"
  spec.version       = VirtualProxy::VERSION
  spec.authors       = ["John Careaga"]
  spec.email         = ["johnc219dev@gmail.com"]

  spec.summary       = %q{Quickly build virtual proxies.}
  spec.description   = %q{Forward messages to lazily-evaluated subjects.}
  spec.homepage      = "https://github.com/johnc219/virtual_proxy"
  spec.license       = "MIT"

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
  spec.add_development_dependency "simplecov", "~> 0.16.1"
end
