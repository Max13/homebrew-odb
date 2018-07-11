require_relative "libodb-base"
class LibodbPgsql < LibodbBase
  homepage "http://www.codesynthesis.com/products/odb/"
  url "http://www.codesynthesis.com/download/odb/2.4/libodb-pgsql-2.4.0.tar.gz"
  sha256 "8e365b33617ec8ad8594d488755659dea28eea6463eedcde2ec59655fef20f1d"

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

  def install
    standard_install(STDLIB)
  end

  test do
    (testpath/"test.cpp").write <<-EOS
      #include <odb/pgsql/exceptions.hxx>
      int main()
      {
        try {
          throw odb::pgsql::database_exception("test exception");
        } catch (const odb::pgsql::database_exception &e) {}
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-o", "test", "-lodb-pgsql", "-lodb"
    system "./test"
  end
end
