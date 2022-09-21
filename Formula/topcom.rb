class Topcom < Formula
  desc "Triangulations of point configurations and oriented matroids"
  homepage "https://www.wm.uni-bayreuth.de/de/team/rambau_joerg/TOPCOM/index.html"
  url "https://www.wm.uni-bayreuth.de/de/team/rambau_joerg/TOPCOM-Downloads/TOPCOM-0_17_8.tgz"
  sha256 "3f83b98f51ee859ec321bacabf7b172c25884f14848ab6c628326b987bd8aaab"
  license "GPL-2.0-only"
  revision 4

  bottle do
    root_url "https://github.com/Macaulay2/homebrew-tap/releases/download/topcom-0.17.8_4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0a4422470e7b60624d84ce4a2fc54c8443010de53322517ee536cd91e6556a90"
    sha256 cellar: :any,                 big_sur:        "e7ffcf2cfd8f91cfe46123cbf6c18ce8187aad98c309344aabf714d251ece9a5"
    sha256 cellar: :any,                 catalina:       "3a58cac743b7a65284cbff31ac512c42347d6caa460304660aff7301e33f9c0d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "286298c9d7ac98df13e080bc4f385abdd535339e292ced0ff15645abc25b4277"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  depends_on "cddlib@0.94m"
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
           "CPPFLAGS=-I#{Formula["gmp"].include} -I#{Formula["cddlib@0.94m"].include}/cddlib",
           "LDFLAGS=-L#{Formula["gmp"].lib} -L#{Formula["cddlib@0.94m"].lib}"
    system "make", "install"
  end

  test do
    system "true"
  end
end
