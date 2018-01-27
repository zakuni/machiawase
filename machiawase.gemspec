# -*- encoding: utf-8 -*-
require File.expand_path('../lib/machiawase/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["zakuni"]
  gem.email         = ["kunio038@gmail.com"]
  gem.description   = %q{provides command line usage and library to get a middle point of plural points}
  gem.summary       = %q{finds a middle point of plural points}
  gem.homepage      = "http://zakuni.github.com/machiawase/"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "machiawase"
  gem.require_paths = ["lib"]
  gem.version       = Machiawase::VERSION

  gem.add_dependency "geocoder"
  gem.add_dependency "nokogiri"
  gem.add_dependency "msgpack"
  gem.add_development_dependency "bundler"
  gem.add_development_dependency "rake"
  gem.add_development_dependency "guard"
  gem.add_development_dependency "guard-minitest"
  gem.add_development_dependency "rb-fsevent"
  gem.add_development_dependency "minitest-reporters"

  if RUBY_ENGINE == 'rbx'
    gem.add_dependency 'racc'
    gem.add_dependency 'rubysl', '~> 2.0'
    gem.add_dependency 'psych'
    gem.add_dependency 'json', '~> 1.8'
  end
end
