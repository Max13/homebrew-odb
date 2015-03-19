require "formula"

# Documentation: https://github.com/Homebrew/homebrew/wiki/Formula-Cookbook
#                /usr/local/Library/Contributions/example-formula.rb
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class LibodbMysql < Formula
  homepage "http://www.codesynthesis.com/products/odb/"
  url "http://www.codesynthesis.com/download/odb/2.3/libodb-mysql-2.3.0.tar.gz"
  sha1 "72f92fd60a58cc4b34a8fea23a262dfdaa6c776c"

  depends_on "gcc" => :build
  depends_on "libodb" => :recommended

  def install
    # ENV.deparallelize  # if your formula fails when building in parallel

    # Remove unrecognized options if warned by configure
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install" # if this fails, try separate make/make install steps
  end

  fails_with :clang do
    cause <<-EOS.undent
    Oh! It seems that you only have clang available, or GCC wasn't found!
    Make sure you GCC is installed and recognized by homebrew.
    EOS
  end

  test do
    system "false"
  end
end
