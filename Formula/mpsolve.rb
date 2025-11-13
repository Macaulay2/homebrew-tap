class Mpsolve < Formula
  desc "Multiprecision Polynomial SOLVEr"
  homepage "https://numpi.dm.unipi.it/software/mpsolve"
  url "https://numpi.dm.unipi.it/wp-content/uploads/2025/08/mpsolve-3.2.3.tar.bz2"
  sha256 "1f2e239c698c783b63a5e6903e76316c0335a01d71c466a8551e8a3f790b3971"
  license "GPL-3.0-only"

  bottle do
    root_url "https://ghcr.io/v2/macaulay2/tap"
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "957d23aa020f944069b66b55db4e0504a4a85a155ce26dd17fa2b7d808c5762d"
    sha256 cellar: :any,                 arm64_sonoma:  "bd5af6173a60ca8e1abfe6cb4052c9294930162a1fd93a187014a25c687f0338"
    sha256 cellar: :any,                 ventura:       "376cf13caae1684e38b79c6f2ad8e185dfc5c5487df3898fb301364d0b13cca1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "60ef6228fc1d5a4bc2249ddb33ac1af125f43d53626ced7377249d2f617d60c1"
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
