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
    method_option :command,
                  aliases: "-s",
                  desc: "Use input file list from the result of the given shell command"
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
  -b, [--base-dir=BASE_DIR]                # Base directory
                                           # Default: . (current directory)
  -e, [--exts=one two three]               # List of extension to search for
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
                                           #
  -t, [--theme=THEME]                      # Vim colorscheme to use (optional)
                                           # Default: 'default'
  -c, [--index], [--no-index]              # Generate the index.html file for the result (optional)
                                           # Default: --index
  -s, [--command]                          # Use the input file list from the result of the given shell command
                                           # Note: the command must return the list of file to be valid
                                           # This option ignore any of the following options -e, -f, -n, -x, -i if specified
                                           # e.g. --command 'git diff --name-only HEAD~2 | grep -v test'
                                           # e.g. --command 'find . -type f -iname "*.rb" | grep -v test | grep -v _spec'
Print files to (x)html using Vim
      EOS
    end
    # rubocop:enable All

    default_task :usage

  private

    # Get the list of input file
    #
    # @param [Hash<Symbol, Object>] args the input options
    # @option args [String] :command the shell command to be used to get list of files
    # @return [Array<String>] list of files in the format
    #         ["./Gemfile", "./lib/vim_printer/cli.rb", ..]
    def get_input_files(args = {})
      command  = args.fetch(:command, nil)
      base_dir = args[:base_dir]
      if command.nil?
        CodeLister.files(args)
      else
        CodeLister.files_from_command(command, base_dir)
      end
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
