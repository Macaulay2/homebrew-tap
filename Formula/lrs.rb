class Lrs < Formula
  desc "Vertex enumeration/convex hull problems"
  homepage "https://github.com/mkoeppe/lrslib" # http://cgm.cs.mcgill.ca/~avis/C/lrs.html
  # update
  url "https://github.com/mkoeppe/lrslib/archive/lrslib-070.tar.gz"
  sha256 "0a8e4d9afe0b608333e256a9e4588eb7080ebb0966ae3dcb7df708ba2bde6f90"
  license "GPL-2.0-only"
  revision 1

  bottle do
    root_url "https://github.com/Macaulay2/homebrew-tap/releases/download/lrs-070_1"
    sha256 cellar: :any,                 arm64_monterey: "5bddcdb5ddc8e6160c3a9ea56d020effcd6380338a1aa51450d37cdd68c08b31"
    sha256 cellar: :any,                 big_sur:        "231d4cd321a7bdfd3b3cdfb3e90e90f3a1b582dcfbfb448106ed53035e4dfad0"
    sha256 cellar: :any,                 catalina:       "e25ae0deee94da105d7c4d848e6c77c7222df60b36847eda67d2152ee45afc10"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6199bea799b38a985898f20ae18633226c13df7cae6df3cdaadf540de14aed5e"
  end

  depends_on "gmp"

  def install
    system "make", "lrs", "prefix=#{prefix}", "CC=#{ENV.cc}",
           "INCLUDEDIR=#{Formula["gmp"].include}",
           "LIBDIR=#{Formula["gmp"].lib}"
    bin.install "lrs"
  end

  test do
    system "true"
  end
end
