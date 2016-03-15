require_relative "libodb-base"
class LibodbOracle < LibodbBase
  homepage "http://www.codesynthesis.com/products/odb/"
  url "http://www.codesynthesis.com/download/odb/2.4/libodb-oracle-2.4.0.tar.gz"
  sha256 "57b4d5da5efc262e7fdecd764565fb8e25168838b09604f6815cd3c1c237aa06"

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

  depends_on "libodb" => "with-" + STDLIB

  def install
    standard_install(STDLIB)
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <odb/oracle/exceptions.hxx>
      int main()
      {
        try {
          throw odb::oracle::database_exception("test exception");
        } catch (const odb::oracle::database_exception &e) {}
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-o", "test", "-lodb-oracle", "-lodb"
    system "./test"
  end
end
