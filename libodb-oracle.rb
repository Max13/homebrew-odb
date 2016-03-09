require_relative "libodb-base"
class LibodbOracle < LibodbBase
  url "http://www.codesynthesis.com/download/odb/2.4/libodb-oracle-2.4.0.tar.gz"
  sha256 "57b4d5da5efc262e7fdecd764565fb8e25168838b09604f6815cd3c1c237aa06"

  def install
    standard_install
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
