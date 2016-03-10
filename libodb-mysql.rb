require_relative "libodb-base"
class LibodbMysql < LibodbBase
  url "http://www.codesynthesis.com/download/odb/2.4/libodb-mysql-2.4.0.tar.gz"
  sha256 "95e5b7a4ef3cc5abbb91e7f155b6b74d5e143df99258da1d49097bb7498eefef"

  depends_on "mysql-connector-c"

  def install
    standard_install
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
