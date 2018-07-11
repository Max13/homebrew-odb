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
    if MacOS.version <= :el_capitan
      depends_on "gcc@5"
    else
      depends_on "gcc@4.9"
    end

    fails_with :clang

    STDLIB = "gcc"
  elsif build.with?("libstdc++")
    STDLIB = "libstdc++"
  elsif build.with?("libc++")
    STDLIB = "libc++"
  else
    STDLIB = MacOS.version < :mavericks ? "libstdc++" : "libc++"
  end

  patch do
    url "http://scm.codesynthesis.com/?p=odb/libodb.git;a=patch;h=b119086e8c5835695cd851da8ad1393218aa29df"
    sha256 "860bdab948a72b30397377201be329c9124594026ff088effe85cc87c39de079"
  end

  patch do
    url "http://scm.codesynthesis.com/?p=odb/libodb.git;a=patch;h=ee4d942916d347ac65f53969941b0fb100760611"
    sha256 "d58490df7cc415bd55373aaebc185b5e4e60275a4536a737fcd22196393dd831"
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

    opoo <<-EOS
      Your app, libodb and its libs must be compiled with the same
      C++ standard library. Currently: #{STDLIB}
    EOS
  end

  test do
    (testpath/"test.cpp").write <<-EOS
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
