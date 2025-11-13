class Topcom < Formula
  desc "Triangulations of point configurations and oriented matroids"
  homepage "https://www.wm.uni-bayreuth.de/de/team/rambau_joerg/TOPCOM/index.html"
  url "https://www.wm.uni-bayreuth.de/de/team/rambau_joerg/TOPCOM-Downloads/TOPCOM-1_1_2.tgz"
  sha256 "4fb10754ee5b76056441fea98f2c8dee5db6f2984d8c14283b49239ad4378ab6"
  license "GPL-2.0-only"
  revision 6

  bottle do
    root_url "https://ghcr.io/v2/macaulay2/tap"
    rebuild 2
    sha256 cellar: :any,                 arm64_tahoe:   "35832af090797163c088942ced3c27b987ff085b5807ee79587261e6485571ea"
    sha256 cellar: :any,                 arm64_sequoia: "5aa8c1b2b0639980cb70a12822912d45f0db39daa90c17fb05aa0e03807306f6"
    sha256 cellar: :any,                 arm64_sonoma:  "2a8884f32f3a1c50f5a2a664b840418083d9e1af7e1f0fff19eab1f442df5daa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "07b73acda37b0b7d21a1fa621559688d462e5e2566de31ec98ceab1eaf49089c"
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
