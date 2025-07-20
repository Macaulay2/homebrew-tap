class Fourtitwo < Formula
  desc "Software for algebraic, geometric and combinatorial problems on linear spaces"
  homepage "https://4ti2.github.io/"
  url "https://github.com/4ti2/4ti2/archive/refs/tags/Release_1_6_13.tar.gz"
  sha256 "37b36536f0b9185afa8e0c9badf6a6b5277b7a4a8409726d599cf254946e94fa"
  license "GPL-2.0-or-later"

  bottle do
    root_url "https://ghcr.io/v2/macaulay2/tap"
    sha256 cellar: :any,                 arm64_sequoia: "1bd6153e3e218cdd2ab39c333e7bc175a22d7dfbcd94b33adac7c08010fa341c"
    sha256 cellar: :any,                 arm64_sonoma:  "84317759a6785fc2385b6eeb4c098eea3f60738affebcd423f8980a774c4f74f"
    sha256 cellar: :any,                 ventura:       "1d82ea4ee97d3e351f2694c3691cfd49a4327177bd3317b03e98caea59eec037"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e071a8b56a2ff881e9ac3e39dcb6e29e0cafcc4df2dc525cb6d2a1b3b1448a1e"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  depends_on "glpk"
  depends_on "gmp"

  def install
    system "autoreconf", "-vif"
    system "./configure",
           "--disable-debug",
           "--disable-dependency-tracking",
           "--disable-silent-rules",
           "--with-glpk=#{Formula["glpk"].prefix}",
           "CPPFLAGS=-I#{Formula["gmp"].include}",
           "LDFLAGS=-L#{Formula["gmp"].lib}",
           "--prefix=#{prefix}"
    system "make", "install-strip"
  end

  test do
    system "true"
  end
end
