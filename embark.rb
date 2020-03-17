class Weather < Formula
    desc "A command line tool to help with git releases"
    homepage "https://github.com/ammanvedi/embark"
    url "https://github.com/ammanvedi/embark/archive/v1.0.1.tar.gz"
    sha256 "b1c7ab25dfb4530a5e35aa690d79469de5ec419dd284f03868935c2417e1ee3a"
    version "1.0.1"
  
    depends_on "curl"
  
    bottle :unneeded
  
    def install
      bin.install "embark"
    end
  end