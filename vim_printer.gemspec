# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "vim_printer/version"
Gem::Specification.new do |spec|
  spec.name          = "vim_printer"
  spec.version       = VimPrinter::VERSION
  spec.authors       = ["Burin Choomnuan"]
  spec.email         = ["agilecreativity@gmail.com"]
  spec.description   = %q(Batch convert multiple files to htmls using the power of Vim editor)
  spec.summary       = %q(Batch convert multiple files to htmls using the power of Vim.
                          Work will any languages that can be open with Vim e.g. any non-binary files.)
  spec.homepage      = "https://github.com/agilecreativity/vim_printer"
  spec.required_ruby_version = ">= 1.9.3"
  spec.license       = "MIT"
  spec.files         = Dir.glob("{bin,lib,config}/**/*") + %w[Gemfile
                                                              Rakefile
                                                              vim_printer.gemspec
                                                              README.md
                                                              CHANGELOG.md
                                                              LICENSE
                                                              .rubocop.yml
                                                              .gitignore]
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = Dir.glob("{test}/**/*")
  spec.require_paths = ["lib"]
  spec.add_runtime_dependency "thor", "~> 0.19.1"
  spec.add_runtime_dependency "code_lister", "~> 0.2.2"
  spec.add_runtime_dependency "index_html", "~> 0.2.2"
  spec.add_runtime_dependency "agile_utils", "~> 0.2.2"
  spec.add_development_dependency "bundler", "~> 1.7.0"
  spec.add_development_dependency "rake", "~> 10.3.2"
  spec.add_development_dependency "awesome_print", "~> 1.2.0"
  spec.add_development_dependency "minitest-spec-context", "~> 0.0.3"
  spec.add_development_dependency "guard-minitest", "~> 2.3.1"
  spec.add_development_dependency "minitest", "~> 5.4.0"
  spec.add_development_dependency "guard", "~> 2.6.1"
  spec.add_development_dependency "pry", "~> 0.10.0"
  spec.add_development_dependency "rubocop", "~> 0.24.1"
  spec.add_development_dependency "gem-ctags", "~> 1.0.6"
  spec.add_development_dependency "yard", "~> 0.8.7"
end
