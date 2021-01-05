class Mpsolve < Formula
  desc "Multiprecision Polynomial SOLVEr"
  homepage "https://numpi.dm.unipi.it/software/mpsolve"
  url "https://numpi.dm.unipi.it/_media/software/mpsolve/mpsolve-3.2.1.tar.gz"
  sha256 "3d11428ae9ab2e020f24cabfbcd9e4d9b22ec572cf70af0d44fe8dae1d51e78e"
  license "GPL-3.0-only"
  revision 1

  bottle do
    root_url "https://github.com/mahrud/homebrew-tap/releases/download/mpsolve-3.2.1"
    cellar :any
    sha256 "5b0d39bfe221ffa181e198deb8e01429ddcee7ae4624bc3def014415628377b1" => :catalina
    sha256 "dcc44b785b1c3a626735842c7ad793050d37432878ddccab055390896cbc082c" => :x86_64_linux
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  depends_on "gmp"
  depends_on "mpfr"

  patch do
    url "https://raw.githubusercontent.com/Macaulay2/M2/35c3e5e5f03cb2e60baa8e69f8109afcdb5fdc7b/M2/libraries/mpsolve/patch-3.2.1"
    sha256 "ba5b6064c8a3e9d1894d764aacebe5a623daf1487c7cc44207599df1759036d7"
  end

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
