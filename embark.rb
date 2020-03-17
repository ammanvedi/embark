class Weather < Formula
    desc "A command line tool to help with git releases"
    homepage "https://github.com/ammanvedi/embark"
    url "https://github.com/ammanvedi/embark/archive/v{{version}}.tar.gz"
    version "{{version}}"
  
    depends_on "curl"
  
    bottle :unneeded
  
    def install
      bin.install "embark"
    end
  end
