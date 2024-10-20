class Topcom < Formula
  desc "Triangulations of point configurations and oriented matroids"
  homepage "https://www.wm.uni-bayreuth.de/de/team/rambau_joerg/TOPCOM/index.html"
  url "https://www.wm.uni-bayreuth.de/de/team/rambau_joerg/TOPCOM-Downloads/TOPCOM-1_1_2.tgz"
  sha256 "4fb10754ee5b76056441fea98f2c8dee5db6f2984d8c14283b49239ad4378ab6"
  license "GPL-2.0-only"
  revision 6

  bottle do
    root_url "https://ghcr.io/v2/macaulay2/tap"
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "9cfe425db1a7a352ff89997bfda0ca678c80a9a525b262dd74e03acc2b1bd5a4"
    sha256 cellar: :any,                 arm64_sonoma:  "ae76afe1f58db4c8ba6a5f58ae50e32d701b7e54458850167177ef36d72e98c8"
    sha256 cellar: :any,                 ventura:       "90300227b97e1c68c0a09d86b9bdc06c9bda8483208d12391b7bb6ef7c98e49a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8c5aca5be2e7caffb90437ee5502b384932dd959e3a03e28014a99ef026f5f39"
  end

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
