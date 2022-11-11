class Topcom < Formula
  desc "Triangulations of point configurations and oriented matroids"
  homepage "https://www.wm.uni-bayreuth.de/de/team/rambau_joerg/TOPCOM/index.html"
  # update
  url "https://www.wm.uni-bayreuth.de/de/team/rambau_joerg/TOPCOM-Downloads/TOPCOM-0_17_8.tgz"
  sha256 "3f83b98f51ee859ec321bacabf7b172c25884f14848ab6c628326b987bd8aaab"
  license "GPL-2.0-only"
  revision 5

  bottle do
    root_url "https://github.com/Macaulay2/homebrew-tap/releases/download/topcom-0.17.8_5"
    sha256 cellar: :any,                 arm64_monterey: "0a4422470e7b60624d84ce4a2fc54c8443010de53322517ee536cd91e6556a90"
    sha256 cellar: :any,                 big_sur:        "a46f2f3d4d13998c1abcee1d69c15b96b47081f76cb3da04c17e94c2130be07c"
    sha256 cellar: :any,                 catalina:       "c98f77e405299b8b5376b5f00c8a5c6a8ebc605ae2131931cbb8520e08f2a422"
    sha256 cellar: :any,                 monterey:       "ded3c406caba52d0c83114cf14688433df3225f709a7ed941f09b955983ae9a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dd61807b16a01abbba5b7dd9a656263f5624d1d9f39a3b59c4ea7aa8550f33fc"
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
