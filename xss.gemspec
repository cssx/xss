# -*- encoding: utf-8 -*-
require File.expand_path('../lib/xss/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Ly Tran", "Jacob Dam"]
  gem.email         = ["prtran@gmail.com", "ngocphuc@gmail.com"]
  gem.description   = %q{TODO: Write a gem description}
  gem.summary       = %q{TODO: Write a gem summary}
  gem.homepage      = "https://github.com/lytc/xss"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "xss"
  gem.require_paths = ["lib"]
  gem.version       = XSS::VERSION

  gem.add_runtime_dependency('racc')
  gem.add_runtime_dependency('rlex')
  gem.add_development_dependency('rspec', '~> 2.11')
  gem.add_development_dependency('rake')
end
