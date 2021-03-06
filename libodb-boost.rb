class LibodbBoost < Formula
  homepage "http://www.codesynthesis.com/products/odb/"
  url "https://www.codesynthesis.com/download/odb/2.4/libodb-boost-2.4.0.tar.gz"
  sha256 "39cebeddd617b0af44512ce75fa4e47cd193f2a712bda94b7ed2ca55a8052df4"

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
  depends_on "boost" if build.with?("boost")

  def install
    if build.with?("libstdc++")
      def_stdlib = "libstdc++"
    elsif build.with?("libc++")
      def_stdlib = "libc++"
    else
      def_stdlib = MacOS.version < :mavericks ? "libstdc++" : "libc++"
    end

    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]

    if STDLIB != "gcc"
      args << "CXX=#{ENV.cxx}\ -stdlib=#{STDLIB}"
    end

    system "./configure", *args
    system "make", "install"

    opoo <<-EOS
      Your app, libodb and its libs must be compiled with the same
      C++ standard library. Currently: #{STDLIB}
    EOS
  end

  test do
    (testpath/"test.cpp").write <<-EOS
      int main()
      {
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-o", "test", "-lodb-boost", "-lodb"
    system "./test"
  end
end
