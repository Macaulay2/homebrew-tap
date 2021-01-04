class Frobby < Formula
  desc "Computations With Monomial Ideals"
  homepage "https://www.broune.com/frobby/"
  url "https://github.com/Macaulay2/frobby.git", using: :git, branch: "master"
  version "0.9.1"
  license "GPL-2.0-only"

  depends_on "gmp"

  def install
    system "make", "prefix=#{prefix}", "BIN_INSTALL_DIR=#{bin}",
           "GMP_INC_DIR=#{Formula["gmp"].include}",
           "LDFLAGS=-L#{Formula["gmp"].lib}",
           "CXXFLAGS=-std=gnu++11"
    system "make", "install", "DESTDIR=#{prefix}"
  end

  test do
    system "true"
  end
end
