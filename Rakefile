require "bundler/gem_tasks"
require "rake/testtask"

Rake::TestTask.new do |t|
  t.libs << 'lib/vim_printer'
  t.test_files = FileList['test/lib/vim_printer/test_*.rb']
  t.verbose = true
end

task :default => :test

task :pry do
  require 'pry'
  require 'awesome_print'
  require 'vim_printer'
  include VimPrinter
  ARGV.clear
  Pry.start
end
