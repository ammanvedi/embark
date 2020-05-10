class Embark < Formula
    desc "A command line tool to help with git releases"
    homepage "https://github.com/ammanvedi/embark"
    url "https://github.com/ammanvedi/embark/archive/v2.0.10.tar.gz"
    version "2.0.10"
  
    bottle :unneeded
  
    def install
      bin.install "bin/embark"
    end
  end
