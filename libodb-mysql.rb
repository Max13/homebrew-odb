require_relative "libodb-base"
class LibodbMysql < LibodbBase
  homepage "http://www.codesynthesis.com/products/odb/"
  url "http://www.codesynthesis.com/download/odb/2.4/libodb-mysql-2.4.0.tar.gz"
  sha256 "95e5b7a4ef3cc5abbb91e7f155b6b74d5e143df99258da1d49097bb7498eefef"

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
  depends_on "mysql-connector-c"

  def install
    standard_install(STDLIB)
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <odb/mysql/exceptions.hxx>
      int main()
      {
        try {
          throw odb::mysql::database_exception(0, "state", "message");
        } catch (const odb::mysql::database_exception &e) {}
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-o", "test", "-lodb-mysql", "-lodb"
    system "./test"
  end
end
