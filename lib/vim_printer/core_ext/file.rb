# from: http://blade.nagaokaut.ac.jp/cgi-bin/scat.rb/ruby/ruby-talk/44936
class File
  # Note: monkey patch to check if a given file is a binary
  def self.binary?(name)
    name = File.expand_path(name)
    my_stat = stat(name)
    return false unless my_stat.file?
    open(name) do |file|
      blk = file.read(my_stat.blksize)
      if blk
        return blk.size == 0 || blk.count("^ -~", "^\r\n") / blk.size > 0.3 || blk.count("\x00") > 0
      else
        false
      end
    end
  end
end
