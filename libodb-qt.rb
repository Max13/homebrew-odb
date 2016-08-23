class LibodbQt < Formula
  homepage "http://www.codesynthesis.com/products/odb/"
  url "http://www.codesynthesis.com/download/odb/2.4/libodb-qt-2.4.0.tar.gz"
  sha256 "f48c563f653df178866301e4c5069b09b697d98f54dcc9ef8714157002156183"

  option "with-libstdc++",
         "Force compiling with libstdc++ (Default BEFORE 10.9)"
  option "with-libc++",
         "Force compiling with libc++ (Default SINCE 10.9)"
  option "with-gcc",
         "Force compiling with gcc and GCC's libstdc++"

  if build.with?("gcc")
    depends_on "gcc5"

    fails_with :clang
    fails_with :llvm

    STDLIB = "gcc"
  elsif build.with?("libstdc++")
    STDLIB = "libstdc++"
  elsif build.with?("libc++")
    STDLIB = "libc++"
  else
    STDLIB = MacOS.version < :mavericks ? "libstdc++" : "libc++"
  end

  depends_on "libodb" => "with-" + STDLIB
  depends_on "qt5" if build.with?("qt5")

  if !ENV["QMAKE"] || ENV["QMAKE"].empty?
    QMAKE = `which qmake`.rstrip
    if QMAKE.empty?
      depends_on "qt"
    end
  else
    QMAKE = ENV["QMAKE"]
  end

  def install
    unless QMAKE
      onoe <<-EOS.undent
        Qt is a dependency, but you chose \"--without-qt\".
        You need to indicate \`qmake\` path to homebrew as:
          QMAKE=~/Qt/5.4/clang_64/bin/qmake brew install libodb-qt
      EOS
      exit 1
    end

    qtlib = `#{QMAKE} -v | tail -n1 | cut -d' ' -f6`.strip

    if build.with?("libstdc++")
      def_stdlib = "libstdc++"
    elsif build.with?("libc++")
      def_stdlib = "libc++"
    else
      def_stdlib = MacOS.version < :mavericks ? "libstdc++" : "libc++"
    end

    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      CPPFLAGS=-F#{qtlib}
      LDFLAGS=-F#{qtlib}
    ]

    if STDLIB != "gcc"
      args << "CXX=#{ENV.cxx}\ -stdlib=#{STDLIB}"
    end

    system "./configure", *args
    system "make", "install"

    File.open(etc/"odb/default.options", "a") do |f|
      f << "\n"
      f << "-x -F#{qtlib}\n"
      f << "-x -I#{qtlib}/QtCore.framework/Headers\n"
      f << "-x -I#{qtlib}/QtGui.framework/Headers\n"
      f << "-x -I#{qtlib}/QtWidgets.framework/Headers\n"
    end

    opoo <<-EOS.undent
      Your app, libodb and its libs must be compiled with the same
      C++ standard library. Currently: #{STDLIB}
    EOS
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <odb/qt/exception.hxx>
      struct qt_exception : odb::qt::exception
      {
        virtual const char*
        what () const throw () {return 0;};

        virtual qt_exception*
        clone () const {return 0;}
      };

      int main()
      {
        try {
          throw qt_exception();
        } catch (const qt_exception &e) {}
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-o", "test", "-lodb-qt", "-lodb"
    system "./test"
  end
end
