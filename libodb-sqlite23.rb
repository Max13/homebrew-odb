require "formula"

# Documentation: https://github.com/Homebrew/homebrew/wiki/Formula-Cookbook
#                /usr/local/Library/Contributions/example-formula.rb
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class LibodbSqlite23 < Formula
  homepage "http://www.codesynthesis.com/products/odb/"
  url "http://www.codesynthesis.com/download/odb/2.3/libodb-sqlite-2.3.0.tar.gz"
  sha1 "2643d3c2c3f273f3fb223759e4ad10635cc91ce8"

  # depends_on "gcc" => :build
  depends_on "libodb" => :recommended
  option     "without-libodb", "Don't install libodb"

  def install
    # ENV.deparallelize  # if your formula fails when building in parallel

    # Remove unrecognized options if warned by configure
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "CC=clang", "CXX=clang++ -stdlib=libstdc++",
                          "LDFLAGS=-L/usr/lib",
                          "LIBS=-lstdc++"
    system "make", "install" # if this fails, try separate make/make install steps
  end

  # fails_with :clang do
  #   cause <<-EOS.undent
  #   Oh! It seems that you only have clang available, or GCC wasn't found!
  #   Make sure you GCC is installed and recognized by homebrew.
  #   EOS
  # end

  test do
    system "false"
  end
end
