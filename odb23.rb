class Odb23 < Formula
  homepage "http://www.codesynthesis.com/products/odb/"
  url "http://www.codesynthesis.com/download/odb/2.3/odb-2.3.0.tar.gz"
  sha256 "677c9024a7aa5f2b6494e8b2755cc6c40dd2acf688e83f32d5ad89ed1a61049d"

  depends_on "libcutl18"
  depends_on "gcc"

  patch do
    url "http://scm.codesynthesis.com/?p=odb/odb.git;a=patch;h=97281fd4454596834142fa43f83af38695b38e5b"
    sha256 "69707b87df0b3faf99128efa9db0ff624caca8ad62930dd01f7e6f68728563e8"
  end

  patch do
    url "http://scm.codesynthesis.com/?p=odb/odb.git;a=patch;h=4617f8f3b0c07a40d46bb04ab4b66e8446a8250b"
    sha256 "4d48924659d181cf1b5970e3482aed6342c1525b8810cabb61f6ae9c4a96d695"
  end

  patch do
    url "http://scm.codesynthesis.com/?p=odb/odb.git;a=patch;h=4f54aea0a7a1735502c845524ae5d650eb630181"
    sha256 "2f4ead4d30ee38aa7a13861b63f687fdeab11fa847d7a89849777ff171f99885"
  end

  fails_with :clang do
    cause "The odb compiler is a gcc plugin, it must be built with gcc"
  end

  fails_with :llvm do
    cause "The odb compiler is a gcc plugin, it must be built with gcc"
  end

  def install
    gcc_short_version = `echo $CXX | cut -d- -f2`.strip
    gcc_plugin_dir = `echo $(dirname $($CXX -print-libgcc-file-name))/plugin/include`.strip

    if !File.exist?("#{gcc_plugin_dir}/libiberty.h")
      ln_s "#{gcc_plugin_dir}/libiberty-#{gcc_short_version}.h",
           "#{gcc_plugin_dir}/libiberty.h",
           :force => true
    end

    File.open("doc/default.options", 'w') {|f|
      f << "# Default ODB options file. This file is automatically loaded by the ODB\n"
      f << "# compiler and can be used for installation-wide customizations, such as\n"
      f << "# adding an include search path for a commonly used library. For example:\n"
      f << "#\n"
      f << "# -I /opt/boost_1_45_0\n"
      f << "#\n"
    }

    system "./configure", "--prefix=#{prefix}",
                          "--libexecdir=#{lib}",
                          "--with-options-file=#{prefix}/etc/odb/default.options",
                          "CXXFLAGS=-fno-devirtualize"
    system "make", "install"

    (prefix/"etc/odb").install "doc/default.options"
  end

  test do
    (testpath/"test.hxx").write <<-EOS.undent
    #include <odb/core.hxx>
    #pragma db object
    class person
    {
      private:
      #pragma db id auto
      unsigned long id_;
      unsigned short age_;

      friend class odb::access;
      person(){}

      public:
      person (unsigned short age):age_(age){}

      unsigned short age()const{return age_;}

      void age(unsigned short age){age_=age;}
    };
    EOS
    system "odb", "-d", "sqlite", "-s", "-q", "test.hxx"
  end
end
