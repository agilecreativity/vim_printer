require_relative '../../test_helper'
require 'zlib'
require 'fileutils'

describe VimPrinter::Utility do

  def setup
    @files = VimPrinter::Utility.find("test/fixtures/outputs")
  end

  def teardown
    @files = []
  end

  context '#find' do
    it 'contains proper list of files' do
      @files.wont_be_empty
    end
  end

  context '#tar_gzip_files' do
    before do
      FileUtils.rm_rf("test/output.tar.gz")
    end

    after do
      FileUtils.rm_rf("test/output.tar.gz")
    end

    it 'compresses list of files' do
      files = VimPrinter::Utility.find("test/fixtures/outputs")
      refute File.exists?("test/output.tar.gz"), "Output file must not exist"
      VimPrinter::Utility.tar_gzip_files(files, "test/output.tar.gz")
      assert File.exists?("test/output.tar.gz"), "Output file must be generated"
    end
  end

  # TODO: come and revisit this test
  # context '#delete' do
  #   it 'removes the files' do
  #     puts 'remove generated files'
  #     @files.wont_be_empty
  #     VimPrinter::Utility.delete(@files)
  #     #TODO: assert that the files were actually deleted!
  #   end
  # end

end
