require_relative "libodb-base"
class LibodbSqlite < LibodbBase
  homepage "http://www.codesynthesis.com/products/odb/"
  url "http://www.codesynthesis.com/download/odb/2.4/libodb-sqlite-2.4.0.tar.gz"
  sha256 "cd687c882a8dc14ded4eb160e82de57e476b1feef5c559c5a6a5c7e671a10cf4"

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

  depends_on "libodb" => "with-" + STDLIB

  patch do
    url "http://scm.codesynthesis.com/?p=odb/libodb-sqlite.git;a=patch;h=27a578709046a81bb0efc0027bfc74318615447e"
    sha256 "daa40de58d78efc1d9b65e2cc767c4e72a26ceb8a8b8fde5e2d8e2d310a9a535"
  end

  def install
    standard_install(STDLIB)
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <odb/sqlite/exceptions.hxx>
      int main()
      {
        try {
          throw odb::sqlite::forced_rollback();
        } catch (const odb::sqlite::forced_rollback &e) {}
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-o", "test", "-lodb-sqlite", "-lodb"
    system "./test"
  end
end
