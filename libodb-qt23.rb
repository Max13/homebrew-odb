require "formula"

# Documentation: https://github.com/Homebrew/homebrew/wiki/Formula-Cookbook
#                /usr/local/Library/Contributions/example-formula.rb
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class LibodbQt23 < Formula
  homepage "http://www.codesynthesis.com/products/odb/"
  url "http://www.codesynthesis.com/download/odb/2.3/libodb-qt-2.3.1.tar.gz"
  sha1 "7931df04fc746101356e170297002d90a3e1fd21"

  # depends_on "gcc" => :build
  depends_on "libodb" => :recommended
  option     "without-libodb", "Don't install libodb"
  depends_on "qt" => :optional
  option     "with-qt", "Install the qt library"

  def install
    qmake = `which qmake`.strip

    if qmake.empty?
      qmake = "#{ENV['QMAKE']}"
      if qmake.empty?
        onoe "    You need to indicate \`qmake\` path to homebrew as:
             QMAKE=~/Qt/5.3/clang_64/bin/qmake brew install libodb-qt".undent
        exit 1
      end
    end

    qtlib = `#{qmake} -v | tail -n1 | cut -d' ' -f6`.strip

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "CPPFLAGS=-F#{qtlib}",
                          "LDFLAGS=-F#{qtlib} -L/usr/lib",
                          "CC=clang", "CXX=clang++ -stdlib=libstdc++",
                          "LIBS=-lstdc++"
    system "make", "install" # if this fails, try separate make/make install steps

    if File.file?(etc/"odb/default.options")
      File.open(etc/"odb/default.options", 'a') {|f|
        f << "\n"
        f << "-x -I#{HOMEBREW_PREFIX}/include\n"
        f << "-x -F#{qtlib}\n"
        f << "-x -I#{qtlib}/QtCore.framework/Headers\n"
        f << "-x -I#{qtlib}/QtGui.framework/Headers\n"
        f << "-x -I#{qtlib}/QtWidgets.framework/Headers\n"
      }
    end
  end

  # fails_with :clang do
  #   cause <<-EOS.undent
  #   Oh! It seems that you only have clang available, or GCC wasn't found!
  #   Make sure you GCC is installed and recognized by homebrew.
  #   EOS
  # end

  test do
    system "false"
  end
end
