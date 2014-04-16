require 'logger'
module VimPrinter
  class << self
    attr_writer :logger
      # @return [Logger] the Logger for the project
      def logger
        @logger ||= Logger.new STDOUT
      end
  end
end
