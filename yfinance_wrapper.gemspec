# frozen_string_literal: true

require_relative "lib/yfinance_wrapper/version"

Gem::Specification.new do |spec|
  spec.name = "yfinance_wrapper"
  spec.version = YfinanceWrapper::VERSION
  spec.authors = ["ys7i"]
  spec.email = ["s7i.yuhi@gmail.com"]

  spec.summary = "A Ruby wrapper for Yahoo Finance API"
  spec.description = "A simple and easy-to-use Ruby wrapper library for Yahoo Finance API"
  spec.homepage = "https://github.com/ys7i/yfinance_wrapper"
  spec.required_ruby_version = ">= 3.0.0"

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/ys7i/yfinance_wrapper"
  spec.metadata["changelog_uri"] = "https://github.com/ys7i/yfinance_wrapper/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .github appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  spec.add_dependency "pycall", "~> 1.5.2"
  spec.add_development_dependency "numpy", "~> 0.4.0"
  spec.add_development_dependency "pandas", "~> 0.3.8"
  spec.add_development_dependency "rspec", "~> 3.0"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
