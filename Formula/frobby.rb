class Frobby < Formula
  desc "Computations With Monomial Ideals"
  homepage "https://www.broune.com/frobby/"
  url "https://github.com/Macaulay2/frobby.git", using: :git, branch: "Macaulay2-patches"
  version "0.9.1"
  license "GPL-2.0-only"
  revision 1

  bottle do
    root_url "https://github.com/mahrud/homebrew-tap/releases/download/frobby-0.9.1_1"
    cellar :any_skip_relocation
    sha256 "95f24552ab434a7fddc2d08e095c98b1a719cf0be68775e2f12e2307fd50c0fb" => :catalina
    sha256 "19ec7b6be040ba918dfafdc7d8eb255f4a07acd44cf8c80e8794a8b008eb9108" => :x86_64_linux
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
    lib.install "bin/libfrobby.a"
  end

  test do
    system "true"
  end
end
