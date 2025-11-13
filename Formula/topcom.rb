class Topcom < Formula
  desc "Triangulations of point configurations and oriented matroids"
  homepage "https://www.wm.uni-bayreuth.de/de/team/rambau_joerg/TOPCOM/index.html"
  url "https://www.wm.uni-bayreuth.de/de/team/rambau_joerg/TOPCOM-Downloads/TOPCOM-1_1_2.tgz"
  sha256 "4fb10754ee5b76056441fea98f2c8dee5db6f2984d8c14283b49239ad4378ab6"
  license "GPL-2.0-only"
  revision 6

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  depends_on "cddlib"
  depends_on "gmp"

  def install
    # An error occurs when the C++ compiler is detected as "clang++ -std=gnu++11"
    inreplace "external/Makefile", "CC=${CXX}", "CC=\"${CXX}\""

    # ENV.deparallelize
    system "autoreconf", "-vif"
    system "./configure",
           "--disable-dependency-tracking",
           "--disable-silent-rules",
           "--prefix=#{prefix}",
           "CPPFLAGS=-I#{Formula["gmp"].include} -I#{Formula["cddlib"].include}/cddlib",
           "LDFLAGS=-L#{Formula["gmp"].lib} -L#{Formula["cddlib"].lib}"
    system "make", "install-strip"
  end

  test do
    system "true"
  end
end
