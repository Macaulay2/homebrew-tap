class Topcom < Formula
  desc "Triangulations of point configurations and oriented matroids"
  homepage "https://www.wm.uni-bayreuth.de/de/team/rambau_joerg/TOPCOM/index.html"
  url "https://www.wm.uni-bayreuth.de/de/team/rambau_joerg/TOPCOM-Downloads/TOPCOM-0_17_8.tgz"
  sha256 "3f83b98f51ee859ec321bacabf7b172c25884f14848ab6c628326b987bd8aaab"
  license "GPL-2.0-only"
  revision 2

  bottle do
    root_url "https://github.com/Macaulay2/homebrew-tap/releases/download/topcom-0.17.8_2"
    rebuild 1
    sha256 cellar: :any,                 catalina:     "3fa04e8c932879db96a9b51b471ca45c76f6d0005def7a2c61709980cbe3622a"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "7ab454f72c073eefacb21954a89ee6c0d871abdbcd22337fc01cfdadc9d3b72e"
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
