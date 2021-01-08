class Frobby < Formula
  desc "Computations With Monomial Ideals"
  homepage "https://www.broune.com/frobby/"
  url "https://github.com/Macaulay2/frobby.git", using: :git, branch: "Macaulay2-patches"
  version "0.9.1"
  license "GPL-2.0-only"
  revision 3

  bottle do
    root_url "https://github.com/mahrud/homebrew-tap/releases/download/frobby-0.9.1_3"
    cellar :any_skip_relocation
    sha256 "b25a5b4bdc0cf2e29a694213bc7c4c683c047d641c5bea01f8a932e30995d152" => :catalina
    sha256 "1a2615f7852697c0d78734de413b9d13936a01d3957be22aa5539ddb29edd151" => :x86_64_linux
  end

  unless OS.mac?
    fails_with gcc: "4"
    fails_with gcc: "5"
    depends_on "gcc@9" => :build
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
