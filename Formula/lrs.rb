class Lrs < Formula
  desc "Vertex enumeration/convex hull problems"
  homepage "https://github.com/mkoeppe/lrslib" # http://cgm.cs.mcgill.ca/~avis/C/lrs.html
  url "https://github.com/mkoeppe/lrslib/archive/lrslib-070.tar.gz"
  sha256 "0a8e4d9afe0b608333e256a9e4588eb7080ebb0966ae3dcb7df708ba2bde6f90"
  license "GPL-2.0-only"

  bottle do
    root_url "https://github.com/mahrud/homebrew-tap/releases/download/lrs-070"
    cellar :any
    sha256 "f2626c93c319df8fbc8bbbfbd514fca26a50bbc3d6cf28cc622553c378e2fab8" => :catalina
    sha256 "e64d40699b361c80c21d52085226a1fda998c67eb51684d16b65b58b2b0f7f8a" => :x86_64_linux
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
