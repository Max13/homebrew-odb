require_relative "libodb-base"
class LibodbMssql < LibodbBase
  homepage "http://www.codesynthesis.com/products/odb/"
  url "http://www.codesynthesis.com/download/odb/2.4/libodb-mssql-2.4.0.tar.gz"
  sha256 "7863ce814c144cbd464709018007918c19ba71760e484022faa2fa5bf40bdfe7"

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
  depends_on "libiodbc"

  def install
    standard_install(STDLIB)
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <odb/mssql/exceptions.hxx>
      int main()
      {
        try {
          throw odb::mssql::database_exception();
        } catch (const odb::mssql::database_exception &e) {}
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-o", "test", "-lodb-mssql", "-lodb"
    system "./test"
  end
end
