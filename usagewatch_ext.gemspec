# coding: utf-8
# frozen_string_literal: true

lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "usagewatch_ext/version"

Gem::Specification.new do |spec|
  spec.name          = "psm-ruby-stats"
  spec.version       = UsagewatchExt::VERSION
  spec.authors       = ["Personal Social Media"]
  spec.email         = ["contact@personalsocialmedia.net"]
  spec.description   = "A Ruby Gem with methods to find usage statistics such as CPU, Disk, TCP/UDP Connections, Load, Bandwidth, Disk I/O, and Memory"
  spec.summary       = "Extended version of usagewatch_ext"
  spec.homepage      = "https://github.com/personal-social-media/ruby-stats"
  spec.license       = "MIT"
  spec.rdoc_options << "--main" << "README"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency("usagewatch", "~> 0.0.6")
  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "rubocop-rails_config"
end
