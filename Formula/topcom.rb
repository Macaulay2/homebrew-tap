class Topcom < Formula
  desc "Triangulations of point configurations and oriented matroids"
  homepage "http://www.rambau.wm.uni-bayreuth.de/TOPCOM/"
  url "http://www.rambau.wm.uni-bayreuth.de/Software/TOPCOM-0.17.8.tar.gz"
  sha256 "3f83b98f51ee859ec321bacabf7b172c25884f14848ab6c628326b987bd8aaab"
  license "GPL-2.0-only"
  revision 2

  bottle do
    root_url "https://github.com/Macaulay2/homebrew-tap/releases/download/topcom-0.17.8_2"
    cellar :any
    sha256 "04bb3f8321e6a3be1c1968984282244dd2b8b072784859ea09317cef7e9b505c" => :catalina
    sha256 "8bf4db44249ae523817f236f0d78d919b6fd05c6000c7e023ee111c1c892a540" => :x86_64_linux
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  depends_on "cddlib@0.94"
  depends_on "gmp"

  patch do
    url "https://raw.githubusercontent.com/Macaulay2/M2/3fada9319ecfabfb0a215967c54df0b9496ab1a8/M2/libraries/topcom/patch-0.17.8"
    sha256 "c30d30eddf698b2b1f1f4619b42bb75711758213de4e0005b217a29a64d23e20"
  end

  def install
    # ENV.deparallelize
    system "autoreconf", "-vif"
    system "./configure",
           "--disable-dependency-tracking",
           "--disable-silent-rules",
           "--prefix=#{prefix}",
           "CPPFLAGS=-I#{Formula["gmp"].include} -I#{Formula["cddlib"].include}/cddlib",
           "LDFLAGS=-L#{Formula["gmp"].lib} -L#{Formula["cddlib"].lib}"
    system "make", "install"
  end

  test do
    system "true"
  end
end
