class Libcutl < Formula
  homepage "http://www.codesynthesis.com/projects/libcutl/"
  url "http://www.codesynthesis.com/download/libcutl/1.9/libcutl-1.9.0.tar.gz"
  sha256 "1b575aa8ed74aa36adc0f755ae9859c6e48166a60779a5564dd21b8cb05afb7d"

  option "with-gcc",
         "Force compiling with gcc and GCC's libstdc++ (Forced when compiling odb)"
  option "with-libstdc++",
         "Force compiling with libstdc++ (Default BEFORE 10.9)"
  option "with-libc++",
         "Force compiling with libc++ (Default SINCE 10.9)"

  if build.with?("gcc")
    depends_on "gcc"

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

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]

    if STDLIB != "gcc"
      args << "CXX=#{ENV.cxx}\ -stdlib=#{STDLIB}"
    end

    system "./configure", *args
    system "make", "install"
  end

  test do
    system "curl", "--compressed", "-o", "test.cpp", "-#", "-B", "http://scm.codesynthesis.com/?p=libcutl/libcutl.git;a=blob_plain;f=tests/compiler/traversal/driver.cxx;h=65580aa6e0be16e23989f31e123610ff56782b75;hb=a897445b7d0b8f62825fc51da6de616ec360e612"
    system ENV.cxx, "test.cpp", "-o", "test", "-lcutl"
    system "./test"
  end
end
