require "bundler/gem_tasks"
require "rake/testtask"
Rake::TestTask.new do |t|
  t.libs << "lib/vim_printer"
  t.test_files = FileList["test/lib/vim_printer/test_*.rb"]
  t.verbose = true
end
task default: [:test, :rubocop]
task :pry do
  require "pry"
  require "awesome_print"
  require "vim_printer"
  include VimPrinter
  ARGV.clear
  Pry.start
end

require "rubocop/rake_task"
desc "Run RuboCop on the lib directory"
RuboCop::RakeTask.new(:rubocop) do |task|
  task.patterns = ["lib/**/*.rb"]
  # only show the files with failures
  task.formatters = ["files"]
  # don't abort rake on failure
  task.fail_on_error = false
end
