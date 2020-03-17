class Weather < Formula
    desc "A command line tool to help with git releases"
    homepage "https://github.com/ammanvedi/embark"
    url "https://github.com/ammanvedi/embark/archive/v1.1.2.tar.gz"
    version "1.1.2"
  
    depends_on "curl"
  
    bottle :unneeded
  
    def install
      bin.install "embark"
    end
  end
