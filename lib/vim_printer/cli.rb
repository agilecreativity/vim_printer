require 'code_lister'
require_relative '../vim_printer'

module VimPrinter

  class CLI < CodeLister::BaseCLI

    desc 'print', 'Print the list of files'

    shared_options

    method_option :theme,
                  aliases: "-t",
                  desc: "Vim colorscheme to use",
                  default: "default"
    def print
      opts = options.symbolize_keys
      if opts[:version]
        puts "You are using VimPrinter version #{VimPrinter::VERSION}"
        exit
      end
      puts "FYI: your options #{opts}"
      execute(opts)
    end

    desc "usage", "Display help screen"
    def usage
      puts <<-EOS
Usage:
  vim_printer print

Options:
  -b, [--base-dir=BASE_DIR]                # Base directory
                                           # Default: /home/bchoomnuan/Dropbox/spikes/vim_printer
  -e, [--exts=one two three]               # List of extensions to search for
  -f, [--non-exts=one two three]           # List of files without extension to search for
  -n, [--inc-words=one two three]          # List of words to be included in the result if any
  -x, [--exc-words=one two three]          # List of words to be excluded from the result if any
  -i, [--ignore-case], [--no-ignore-case]  # Match case insensitively
                                           # Default: true
  -r, [--recursive], [--no-recursive]      # Search for files recursively
                                           # Default: true
  -v, [--version], [--no-version]          # Display version information
  -t, [--theme=THEME]                      # Vim colorscheme to use
                                           # Default: default

Print the list of files
      EOS
    end

    default_task :usage

    private

    # @param args [Hash<Symbol, Object>] options argument
    def execute(options = {})

      input_files = CodeLister.files(options)

      if input_files.empty?
        puts "No file found for your option: #{options}"
        return
      end
      to_htmls(input_files, options)

      # search for files that we created
      generated_files = VimPrinter::Utility.find(options[:base_dir])

      # tar.gzip them for user
      VimPrinter::Utility.tar_gzip_files(generated_files, 'output.tar.gz')

      # cleanup after ourself
      VimPrinter::Utility.delete(generated_files)

      # report the result
      puts "Your result should be available at `output.tar.gz`"
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

      raise "Invalid input file #{filename}" unless File.exists?(filename)

      # sensible argument, see :help :TOhtml (from Vim)
      command = [
        "vim",
        "-E",
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
        "> /dev/null"
      ]

      # Note: have to run as system only
      system(command.concat(args).join(" "))
    end
  end
end
