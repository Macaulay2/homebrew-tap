class Latte < Formula
  desc "Software for counting lattice points and integration over convex polytopes"
  homepage "https://github.com/latte-int/latte"
  url "https://github.com/latte-int/latte/releases/download/version_1_7_6/latte-int-1.7.6.tar.gz"
  sha256 "006c10ebe5d5bfdc9b159cba6264a4432861fe763ce05fe821624ab7d3fc2170"
  license "GPL-2.0-only"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  # TODO: depends_on "4ti2"
  depends_on "cddlib"
  depends_on "gmp"
  depends_on "ntl"
  depends_on "topcom"

  def install
    system "./configure", *std_configure_args,
           "--disable-silent-rules",
           "--prefix=#{prefix}",
           "CPPFLAGS=-I#{Formula["gmp"].include} -I#{Formula["ntl"].include} -std=c++11",
           "LDFLAGS=-L#{Formula["gmp"].lib} -L#{Formula["ntl"].lib}"
    system "make", "install-strip"
  end

  test do
    system "true"
  end
end
