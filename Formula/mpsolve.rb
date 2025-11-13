class Mpsolve < Formula
  desc "Multiprecision Polynomial SOLVEr"
  homepage "https://numpi.dm.unipi.it/software/mpsolve"
  url "https://numpi.dm.unipi.it/wp-content/uploads/2025/08/mpsolve-3.2.3.tar.bz2"
  sha256 "1f2e239c698c783b63a5e6903e76316c0335a01d71c466a8551e8a3f790b3971"
  license "GPL-3.0-only"

  bottle do
    root_url "https://ghcr.io/v2/macaulay2/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "d22d547a14ffdae0bc2078c860ab36d88ec3d0cf65750175b6c80fad5f9c5018"
    sha256 cellar: :any,                 arm64_sequoia: "cc0017f9824d8ec1fe2924b7a7361c9ee7458da49e3fcd29ee6793c8b4c2323f"
    sha256 cellar: :any,                 arm64_sonoma:  "465be6630b8a2b163f4637c12b64920a1213cf29bcaddef3872655133317cafc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "00db12f3737f717e921d511ea8d744173ba79fcc8c7c6931b4be001eefb26a39"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "bison" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  depends_on "gmp"
  depends_on "mpfr"

  def install
    ENV.cxx11
    system "autoreconf", "-vif"
    # yacc-generated files shipped in 3.2.3 tarball result in
    # errors when using newer compilers, so we remove them so
    # bison can regenerate them
    rm "src/libmps/monomial/yacc-parser.c"
    rm "src/libmps/monomial/yacc-parser.h"
    system "./configure",
           "--disable-debug",
           "--disable-dependency-tracking",
           "--disable-silent-rules",
           "--disable-examples",
           "--disable-ui",
           "--disable-documentation",
           "GMP_CFLAGS=-I#{Formula["gmp"].include}",
           "GMP_LDFLAGS=-L#{Formula["gmp"].lib}",
           "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "true"
  end
end
