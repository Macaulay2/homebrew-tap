class Mpsolve < Formula
  desc "Multiprecision Polynomial SOLVEr"
  homepage "https://numpi.dm.unipi.it/software/mpsolve"
  url "https://numpi.dm.unipi.it/_media/software/mpsolve/mpsolve-3.2.1.tar.gz"
  sha256 "3d11428ae9ab2e020f24cabfbcd9e4d9b22ec572cf70af0d44fe8dae1d51e78e"
  license "GPL-3.0-only"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  depends_on "gmp"
  depends_on "mpfr"

  def install
    system "autoreconf", "-vif"
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
