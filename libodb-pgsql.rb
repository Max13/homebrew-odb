require_relative "libodb-base"
class LibodbPgsql < LibodbBase
  url "http://www.codesynthesis.com/download/odb/2.4/libodb-pgsql-2.4.0.tar.gz"
  sha256 "8e365b33617ec8ad8594d488755659dea28eea6463eedcde2ec59655fef20f1d"

  def install
    standard_install
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
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
