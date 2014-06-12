require_relative "../../lib/vim_printer/configuration"
module VimPrinter
  class << self
    def update_config
      VimPrinter.configure do |config|
        config.options[:html] = [
          "-c 'let g:html_expand_tabs = 1'",
          "-c 'let g:html_use_css = 1'",
          "-c 'let g:html_no_progress = 1'",
          "-c 'let g:html_number_lines = 0'"
        ]
      end
    end
  end
end
