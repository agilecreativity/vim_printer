# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'vim_printer/version'

Gem::Specification.new do |spec|
  spec.name          = 'vim_printer'
  spec.version       = VimPrinter::VERSION
  spec.authors       = ['Burin Choomnuan']
  spec.email         = ['agilecreativity@gmail.com']
  spec.description   = %q{Print/export files to html using the power of Vim editor}
  spec.summary       = %q{Print/export files to html using the power of Vim}
  spec.homepage      = 'https://github.com/agilecreativity/vim_printer'
  spec.license       = 'MIT'
  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']
  spec.add_runtime_dependency 'thor', '~> 0.18'
  spec.add_runtime_dependency 'code_lister', '~> 0.0.6'
  spec.add_runtime_dependency 'index_html', '~> 0.0.7'
  spec.add_runtime_dependency 'agile_utils', '~> 0.0.8'
  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'awesome_print', '~> 1.2'
  spec.add_development_dependency 'minitest-spec-context', '~> 0.0.3'
  spec.add_development_dependency 'guard-minitest', '~> 2.2'
  spec.add_development_dependency 'minitest', '~> 4.2'
  spec.add_development_dependency 'guard', '~> 2.6'
  spec.add_development_dependency 'pry', '~> 0.9'
  spec.add_development_dependency 'gem-ctags', '~> 1.0'
  spec.add_development_dependency 'yard', '~> 0.8'
end
