class Fourtitwo < Formula
  desc "Software for algebraic, geometric and combinatorial problems on linear spaces"
  homepage "https://4ti2.github.io/"
  url "https://github.com/4ti2/4ti2/archive/refs/tags/Release_1_6_10.tar.gz"
  sha256 "2f1bce3203da65b651d68cbd0ace0f89a16d1f436cf5f24e22bc15ec22df936a"
  license "GPL-2.0-or-later"

  bottle do
    root_url "https://ghcr.io/v2/macaulay2/tap"
    sha256 cellar: :any,                 arm64_sequoia: "3fdadf46b911cd014a9221d2447af0ae19ae1687a1477b89fa25f3f50b931e9c"
    sha256 cellar: :any,                 arm64_sonoma:  "9558d6ee6a212890cc6256df362ef6478161484e4bd07220b7a3513ce63fa2d3"
    sha256 cellar: :any,                 ventura:       "66c465ce694bd27994f925667fb9354906837e92c6fb15334bca385bc7ac185f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0ed17cbc8f60676717e8af67730bbc092f4b4fe8dbbe3d3f91eafedea3d993c8"
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
