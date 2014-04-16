require 'zlib'
require 'stringio'
require 'find'
require 'fileutils'
require 'archive/tar/minitar'

module VimPrinter

  include Archive::Tar
  include Archive::Tar::Minitar

  module Utility

    # @todo use me when you have to!
    CustomError = Class.new(StandardError)

    class << self

      # Find list of files based on certain extension
      # @param [String] bas_dir the starting directory
      # @param [String] extension the file extension to search for
      #
      # @return [Array<String>] list of matching files or empty list
      def find(base_dir, extension = 'xhtml')
        file_paths = []
        Find.find(base_dir) do |path|
          file_paths << path if path =~ /.*\.#{extension}$/
        end
        file_paths || []
      end

      # Tar and gzip list of files
      #
      # @param [Array<String>] files list of input files
      # @param [String] output the output file in .tar.gz format
      def tar_gzip_files(files, output = 'output.tar.gz')
        begin
          sgz = Zlib::GzipWriter.new(File.open(output, 'wb'))
          tar = Minitar::Output.new(sgz)
          files.each do |file|
            Minitar.pack_file(file, tar)
          end
        ensure
          # Closes both tar and sgz.
          tar.close unless tar.nil?
          tar = nil
        end
      end

      # Delete the files from the given list
      def delete(files)
        # Note: should we remove the files and be done with it?
        files.each do |file|
          #puts "FYI: about to delete file #{file}"
          FileUtils.rm_rf(file)
        end
      end

      # Add suffix to each extensions
      #
      # @param [Array<String>] extension list of extension
      # @param [String] suffix the suffix string
      #
      # @return [Array<String>] new list with the suffix added to each element
      def add_suffix(extensions = %w(rb pdf), suffix)
        extensions.map {|e| "#{e}.#{suffix}" }
      end

      # Time the operation before and after the operation for tuning purpose
      def time
        beg_time = Time.now
        yield
        end_time = Time.now
        end_time - beg_time
      end

    end
  end
end

if __FILE__ == $0
  include VimPrinter::Utility
  include Archive::Tar
  include Archive::Tar::Minitar
  files = VimPrinter::Utility.find('test/fixtures/inputs')
  VimPrinter::Utility.tar_gzip_files(files, 'test/fixtures/output.tar.gz')
end
