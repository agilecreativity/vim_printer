require "agile_utils"
require "code_lister"
require "index_html"
require "fileutils"
require_relative "../vim_printer"
require_relative "configuration"
module VimPrinter
  include AgileUtils
  class CLI < Thor
    # rubocop:disable AmbiguousOperator, MethodLength
    desc "print", "Print files to (x)html using Vim"
    method_option *AgileUtils::Options::BASE_DIR
    method_option *AgileUtils::Options::EXTS
    method_option *AgileUtils::Options::NON_EXTS
    method_option *AgileUtils::Options::INC_WORDS
    method_option *AgileUtils::Options::EXC_WORDS
    method_option *AgileUtils::Options::IGNORE_CASE
    method_option *AgileUtils::Options::RECURSIVE
    method_option *AgileUtils::Options::VERSION
    method_option :theme,
                  aliases: "-t",
                  desc:    "Vim colorscheme to use",
                  default: "default"
    method_option :index,
                  aliases: "-c",
                  desc:    "Generate the index.html file for the result",
                  type:    :boolean,
                  default: true
    method_option :shell_command,
                  aliases: "-s",
                  desc: "Use input file list from the result of the given shell command",
                  type: :string
    def print
      opts = options.symbolize_keys
      if opts[:version]
        puts "You are using VimPrinter version #{VimPrinter::VERSION}"
        exit
      end
      execute(opts)
    end

    desc "usage", "Display help screen"
    def usage
      puts <<-EOS
Usage:
  vim_printer

Options:
  -b, [--base-dir=BASE_DIR]                # Base directory (mandatory)
                                           # Default: . (current directory)
  -e, [--exts=one two three]               # List of extension to search for (mandatory)
                                           # e.g. -e rb md
  -f, [--non-exts=one two three]           # List of file without extension to be included in the result (optional)
                                           # e.g. -f Gemfile LICENSE
  -n, [--inc-words=one two three]          # List of word that must be part of the name to be included in the result (optional)
                                           # If this option is not specified then
                                           # all files having the extension specified by -e or all file specified by -f will be included
  -x, [--exc-words=one two three]          # List of words to be excluded from the result if any (optional)
                                           # Use this option to filter out files that contain some word in the name
                                           # e.g. -x '_spec' to exclude files that end with '*_spec.rb' in the name
  -i, [--ignore-case], [--no-ignore-case]  # Match case insensitively apply to both -f, n, and -x options (optional)
                                           # Default: --ignore-case
  -r, [--recursive], [--no-recursive]      # Search for files recursively (optional)
                                           # Default: --recursive
  -v, [--version]                          # Display version information
  -t, [--theme=THEME]                      # Vim colorscheme to use (optional)
                                           # Default: 'default'
  -c, [--index], [--no-index]              # Generate the index.html file for the result (optional)
                                           # Default: --index
  -s, [--shell-command]                    # Use the input file list from the result of the given shell command (optional)
                                           # Note: the command must be result in the list of files
                                           # This option ignore any of the following options -e, -f, -n, -x, -i if specified
                                           # e.g. --shell-command 'git diff --name-only HEAD~2 | grep -v test'
                                           # e.g. --shell-command 'find . -type f -iname "*.rb" | grep -v test | grep -v _spec'
Print files to (x)html using Vim
      EOS
    end
    # rubocop:enable All

    default_task :usage

  private

    # Get the appropriate input from the options
    #
    # @param [Hash<Symbol, Object>] args the input options
    # @option args [String] :shell_input the shell input string if any
    # @return [Array<String>] list of files in the format
    #
    #   ["./Gemfile", "./lib/vim_printer/cli.rb", ..]
    def get_input_files(args = {})
      shell_command = args.fetch(:shell_command, nil)
      if shell_command.nil?
        # use other options if we don't use the '--shell-input' option
        CodeLister.files(args)
      else
        files_from_shell_command(shell_command, args[:base_dir])
      end
    end

    # Execute the command in the shell and return the output list for use
    # e.g. `git diff --name-only HEAD~1` is getting the list of files that have been
    # updated in the last commit
    #
    # @param [String] shell_input the input command to be executed in the shell
    # @param [String] base_dir the starting directory
    # @return [Array<String>] file list or empty list if the shell command is not valid
    def files_from_shell_command(command, base_dir)
      files = AgileUtils::Helper.shell(command.split(" ")).split(/\n/)
      # Adapt the result and make sure that it start with "./"
      # like the result from 'CodeLister.files()' method
      files.map! do |file|
        if file =~ /^\.\//
          # skip if the file start with './' string
          file
        else
          # add './' to the one that does not already have one
          "./#{file}"
        end
      end
      # Note: this make sure that it work with deleted file when use
      # this with 'git diff --name-only HEAD~2'
      files.delete_if { |file| !File.exist?(file.gsub(/^\./, base_dir)) }
    rescue RuntimeError => e
      # just return the empty list, if the user specified invalid command for 'shell_input' option
      return []
    end

    # Main entry point to export the code
    #
    # @param [Hash<Symbol, Object>] options the options argument
    def execute(options = {})
      input_files = get_input_files(options)
      # we want to avoid printing the binary file
      input_files.delete_if do |file|
        File.binary?(file.gsub(/^\./, options[:base_dir]))
      end

      if input_files.empty?
        puts "No file found for your option: #{options}"
        return
      end

      to_htmls(input_files, options)
      generated_files = input_files.map { |f| "#{f}.xhtml" }
      index_file = "./index.html"
      IndexHtml.htmlify generated_files,
                        base_dir: options[:base_dir],
                        output: index_file
      generated_files << index_file if options[:index]
      output_file = "vim_printer_#{File.basename(File.expand_path(options[:base_dir]))}.tar.gz"
      AgileUtils::FileUtil.tar_gzip_files(generated_files, output_file)
      AgileUtils::FileUtil.delete(generated_files)
      FileUtils.rm_rf(index_file) if options[:index]
      puts "Your output file is '#{File.absolute_path(output_file)}'"
    end

    # convert multiple files to html
    def to_htmls(files, options = {})
      FileUtils.chdir(File.expand_path(options[:base_dir]))
      files.each_with_index do |file, index|
        puts "FYI: process file #{index + 1} of #{files.size} : #{file}"
        to_html(file, options)
      end
    end

    def to_html(filename, options = {})
      opts = {
        theme: "seoul256-light"
      }.merge(options)

      fail "Invalid input file #{filename}" unless File.exist?(filename)
      html_options = VimPrinter.configuration.options[:html]

      # sensible argument, see :help :TOhtml (from Vim)
      command = [
        "vim",
        "-E",
        *VimPrinter.configuration.options[:html]
      ]

      # set the colorscheme for the output
      command.push("-c 'colorscheme #{opts[:theme]}'")

      # closing arguments
      args = [
        "-c 'TOhtml'",
        "-c 'w'",
        "-c 'qa!'",
        "#{filename}",
        "> /dev/null"
      ]
      system(command.concat(args).join(" "))
    end
  end
end
