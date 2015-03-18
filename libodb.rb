class Libodb < Formula
  homepage "http://www.codesynthesis.com/products/odb/"
  url "http://www.codesynthesis.com/download/odb/2.4/libodb-2.4.0.tar.gz"
  sha256 "bfb9c398a6fdec675e33b320a1f80bdf74d8fbb700073bf17062f5b3ae1a2d5c"

  option "with-libstdc++",
         "Force compiling with libstdc++ (Default BEFORE 10.9)"
  option "with-libc++",
         "Force compiling with libc++ (Default SINCE 10.9)"
  option "with-gcc",
         "Force compiling with gcc and GCC's libstdc++"

  if build.with?("gcc")
    depends_on "gcc"

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

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]

    if STDLIB != "gcc"
      args << "CXX=#{ENV.cxx}\ -stdlib=#{STDLIB}"
    end

    system "./configure", *args
    system "make", "install"

    opoo <<-EOS.undent
      Your app, libodb and its libs must be compiled with the same
      C++ standard library. Currently: #{STDLIB}
    EOS
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <odb/exceptions.hxx>
      int main()
      {
        try {
          throw odb::null_pointer();
        } catch (const odb::null_pointer &e) {}
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-o", "test", "-lodb"
    system "./test"
  end
end
