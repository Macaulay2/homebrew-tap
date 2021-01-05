class Lrs < Formula
  desc "Vertex enumeration/convex hull problems"
  homepage "https://github.com/mkoeppe/lrslib" # http://cgm.cs.mcgill.ca/~avis/C/lrs.html
  url "https://github.com/mkoeppe/lrslib/archive/lrslib-070.tar.gz"
  sha256 "0a8e4d9afe0b608333e256a9e4588eb7080ebb0966ae3dcb7df708ba2bde6f90"
  license "GPL-2.0-only"

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
