# -*- encoding: utf-8 -*-
require File.expand_path('../lib/machiawase/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["zakuni"]
  gem.email         = ["kunio038@gmail.com"]
  gem.description   = %q{provides command line usage and library to get a middle point of plural points}
  gem.summary       = %q{finds a middle point of plural points}
  gem.homepage      = "https://github.com/zakuni/machiawase"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "machiawase"
  gem.require_paths = ["lib"]
  gem.version       = Machiawase::VERSION

  gem.add_development_dependency "rspec"
  gem.add_development_dependency "ZenTest"
  gem.add_development_dependency "autotest-fsevent"
  gem.add_development_dependency "autotest-growl"
end
