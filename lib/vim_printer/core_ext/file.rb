# From: http://blade.nagaokaut.ac.jp/cgi-bin/scat.rb/ruby/ruby-talk/44936
class File
  def self.binary?(name)
    name = File.expand_path(name)
    myStat = stat(name)
    return false unless myStat.file?
    open(name) do |file|
      blk = file.read(myStat.blksize)
      return blk.size == 0 ||
        blk.count("^ -~", "^\r\n") / blk.size > 0.3 || blk.count("\x00") > 0
    end
  end
end
