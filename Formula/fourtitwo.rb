class Fourtitwo < Formula
  desc "Software for algebraic, geometric and combinatorial problems on linear spaces"
  homepage "https://4ti2.github.io/"
  url "https://github.com/4ti2/4ti2/archive/refs/tags/Release_1_6_13.tar.gz"
  sha256 "37b36536f0b9185afa8e0c9badf6a6b5277b7a4a8409726d599cf254946e94fa"
  license "GPL-2.0-or-later"

  bottle do
    root_url "https://ghcr.io/v2/macaulay2/tap"
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "9815e27ca4ba3d045265ddaa013296d02730301f881233e26de7257c1264c670"
    sha256 cellar: :any,                 arm64_sequoia: "4ce88440f34945d8f881e30094050bf45887f1b21ccd36569608cc195c230e1f"
    sha256 cellar: :any,                 arm64_sonoma:  "8c3da1d5ccac53249024191a7440b994bc5dab0565a9e25c25b2ec4281cc6e82"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4dbcc07e0254d68a4f8e58f6be5f5df0c876158647801d6514feea0b6f912ffe"
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
