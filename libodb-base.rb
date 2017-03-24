class LibodbBase < Formula
  url "http://www.codesynthesis.com/download/odb/2.4/libodb-2.4.0.tar.gz.sha1"
  sha256 "2d26995974eb03b6ba6d26c32f9956e95d5a3d0db6b5fa149a2df7e4773112f4"
  homepage "http://www.codesynthesis.com/products/odb/"

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

  def standard_install(stdlib)
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]

    if stdlib != "gcc"
      args << "CXX=#{ENV.cxx}\ -stdlib=#{stdlib}"
    end

    system "./configure", *args
    system "make", "install"

    opoo <<-EOS.undent
      Your app, libodb and its libs must be compiled with the same
      C++ standard library. Currently: #{stdlib}
    EOS
  end

  def install
    onoe <<-EOS.undent
      Do not install this formula. Instead, install the formula for the database
      you wish to use.
    EOS
    exit 1
  end

  test do
    raise
  end

end
