class Libodb23 < Formula
  homepage "http://www.codesynthesis.com/products/odb/"
  url "http://www.codesynthesis.com/download/odb/2.3/libodb-2.3.0.tar.gz"
  sha256 "44b4035de6d756ecb071a2eea8b883c0e80662284603b6b20b144cb01aae2b30"

  option "with-odb", "Install the ODB compiler"

  depends_on "odb23" => :optional

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
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
