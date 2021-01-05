class Topcom < Formula
  desc "Triangulations of point configurations and oriented matroids"
  homepage "http://www.rambau.wm.uni-bayreuth.de/TOPCOM/"
  url "http://www.rambau.wm.uni-bayreuth.de/Software/TOPCOM-0.17.8.tar.gz"
  sha256 "3f83b98f51ee859ec321bacabf7b172c25884f14848ab6c628326b987bd8aaab"
  license "GPL-2.0-only"
  revision 1

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  depends_on "cddlib@0.94k"
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
           "CPPFLAGS=-I#{Formula["gmp"].include} -I#{Formula["cddlib@0.94k"].include}/cddlib",
           "LDFLAGS=-L#{Formula["gmp"].lib} -L#{Formula["cddlib@0.94k"].lib}"
    system "make", "install"
  end

  test do
    system "true"
  end
end
