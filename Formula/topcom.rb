class Topcom < Formula
  desc "Triangulations of point configurations and oriented matroids"
  homepage "https://www.wm.uni-bayreuth.de/de/team/rambau_joerg/TOPCOM/index.html"
  # update
  url "https://www.wm.uni-bayreuth.de/de/team/rambau_joerg/TOPCOM-Downloads/TOPCOM-1_1_2.tgz"
  sha256 "4fb10754ee5b76056441fea98f2c8dee5db6f2984d8c14283b49239ad4378ab6"
  license "GPL-2.0-only"
  revision 5

  bottle do
    root_url "https://github.com/Macaulay2/homebrew-tap/releases/download/topcom-0.17.8_5"
    sha256 cellar: :any,                 arm64_monterey: "6284b48a829e7c9266520814d951fe69631bfb2d9871bfc697cf9710fa853b5b"
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
