require 'agile_utils'
require 'code_lister'
require 'index_html'
require_relative '../vim_printer'

module VimPrinter
  include AgileUtils

  class CLI < CodeLister::BaseCLI
    desc 'print', 'Print the list of files'

    method_option *AgileUtils::Options::BASE_DIR
    method_option *AgileUtils::Options::EXTS
    method_option *AgileUtils::Options::NON_EXTS
    method_option *AgileUtils::Options::INC_WORDS
    method_option *AgileUtils::Options::EXC_WORDS
    method_option *AgileUtils::Options::IGNORE_CASE
    method_option *AgileUtils::Options::RECURSIVE
    method_option *AgileUtils::Options::THEME
    method_option *AgileUtils::Options::VERSION

    def print
      opts = options.symbolize_keys
      if opts[:version]
        puts "You are using VimPrinter version #{VimPrinter::VERSION}"
        exit
      end
      execute(opts)
    end

    desc 'usage', 'Display help screen'
    def usage
      puts <<-EOS
Usage:
  vim_printer print [OPTIONS]

Options:
  -b, [--base-dir=BASE_DIR]                # Base directory
                                           # Default: . (current directory)
  -e, [--exts=one two three]               # List of extensions to search for
  -f, [--non-exts=one two three]           # List of extensions to search for
  -n, [--inc-words=one two three]          # List of words to be included in the result
  -x, [--exc-words=one two three]          # List of words to be excluded from the result
  -i, [--ignore-case], [--no-ignore-case]  # Match case insensitively
                                           # Default: true
  -r, [--recursive], [--no-recursive]      # Search for files recursively
                                           # Default: true
  -t, [--theme=THEME]                      # Vim colorscheme to use
                                           # Default: default
  -v, [--version], [--no-version]          # Display version information

Print the list of files
      EOS
    end

    default_task :usage

    private

    # Main entry point to export the code
    #
    # @param [Hash<Symbol, Object>] options the options argument
    def execute(options = {})
      input_files = CodeLister.files(options)

      if input_files.empty?
        puts "No file found for your option: #{options}"
        return
      end

      to_htmls(input_files, options)

      # Search for files that we created
      # TODO: may be use the CodeLister.files(..) instead?
      generated_files = AgileUtils::FileUtil.find(options[:base_dir])

      # Generate the 'index.html' file
      index_file = "#{options[:base_dir]}/index.html"

      IndexHtml.htmlify generated_files,
                        base_dir: options[:base_dir],
                        output: index_file

      # Add the missing index file
      generated_files << index_file

      AgileUtils::FileUtil.tar_gzip_files(generated_files, 'output.tar.gz')

      AgileUtils::FileUtil.delete(generated_files)

      # Remove the extra index.html file
      FileUtils.rm_rf(index_file)

      puts "Your output file is #{File.absolute_path('output.tar.gz')}"
    end

    # convert multiple files to 'html'
    def to_htmls(files, options = {})
      files.each_with_index do |file, index|
        puts "FYI: process file #{index + 1} of #{files.size} : #{file}"
        to_html(file, options)
      end
    end

    def to_html(filename, options = {})
      opts = {
        theme: 'seoul256-light'
      }.merge(options)

      fail "Invalid input file #{filename}" unless File.exist?(filename)

      # sensible argument, see :help :TOhtml (from Vim)
      command = [
        'vim',
        '-E',
        "-c 'let g:html_expand_tabs = 1'",
        "-c 'let g:html_use_css = 1'",
        "-c 'let g:html_no_progress = 1'"
      ]

      # set the colorscheme for the output
      command.push("-c 'colorscheme #{opts[:theme]}'")

      # closing arguments
      args = [
        "-c 'TOhtml'",
        "-c 'w'",
        "-c 'qa!'",
        "#{filename}",
        '> /dev/null'
      ]

      # Note: have to run as system only
      system(command.concat(args).join(' '))
    end
  end
end
