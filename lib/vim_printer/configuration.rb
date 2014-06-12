module VimPrinter
  class Configuration
    attr_accessor :options
    def initialize
      @options = {
        # see: :help :TOhtml from Vim for detail
        html: [
          "-c 'let g:html_expand_tabs = 1'",
          "-c 'let g:html_use_css = 1'",
          "-c 'let g:html_no_progress = 1'",
          "-c 'let g:html_number_lines = 0'"
        ]
      }
    end
  end
  class << self
    attr_accessor :configuration
    def configuration
      @configuration ||= Configuration.new
    end
    def configure
      yield configuration
    end
  end
end
