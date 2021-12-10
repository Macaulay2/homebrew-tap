class Topcom < Formula
  desc "Triangulations of point configurations and oriented matroids"
  homepage "https://www.wm.uni-bayreuth.de/de/team/rambau_joerg/TOPCOM/index.html"
  url "https://www.wm.uni-bayreuth.de/de/team/rambau_joerg/TOPCOM-Downloads/TOPCOM-0_17_8.tgz"
  sha256 "3f83b98f51ee859ec321bacabf7b172c25884f14848ab6c628326b987bd8aaab"
  license "GPL-2.0-only"
  revision 3

  bottle do
    root_url "https://github.com/Macaulay2/homebrew-tap/releases/download/topcom-0.17.8_3"
    sha256 cellar: :any,                 big_sur:      "0ee134a31eb8f5cfe08cf683dbbba4efd42fcef25b49c0114822d2b6a04fc7c8"
    sha256 cellar: :any,                 catalina:     "f1d855d1a378f3a29aefed799d340c3d573d8cc3941553b5f6711153fca0266d"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "7c5f3d8997fed0c465190add366b17e0fff204c94d03317db9b92635d484ab21"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  depends_on "cddlib"
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
