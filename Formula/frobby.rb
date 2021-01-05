class Frobby < Formula
  desc "Computations With Monomial Ideals"
  homepage "https://www.broune.com/frobby/"
  url "https://github.com/Macaulay2/frobby.git", using: :git, branch: "Macaulay2-patches"
  version "0.9.1"
  license "GPL-2.0-only"
  revision 2

  bottle do
    root_url "https://github.com/mahrud/homebrew-tap/releases/download/frobby-0.9.1_2"
    cellar :any_skip_relocation
    sha256 "77c95a20c5cb1b96b43a310359a431739a2de976c723dfe04c2f183d264dd245" => :catalina
    sha256 "2842f9dfb03115671e22e9976da9e48871450c5d9d172ea8b0ca9effcde9b085" => :x86_64_linux
  end

  depends_on "binutils" => :build
  depends_on "gmp"

  def install
    ENV.cxx11
    system "make", "bin/libfrobby.a", # "bin/frobby", "BIN_INSTALL_DIR=#{bin}",
           "GMP_INC_DIR=#{Formula["gmp"].include}",
           "LDFLAGS=-L#{Formula["gmp"].lib}",
           "CXXFLAGS=-std=gnu++11",
           "prefix=#{prefix}",
           "CXX=#{ENV.cxx}",
           "RANLIB=ranlib"
    include.install "src/stdinc.h"
    include.install "src/frobby.h"
    lib.install "bin/libfrobby.a"
  end

  test do
    system "true"
  end
end
