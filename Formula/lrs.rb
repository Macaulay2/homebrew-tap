class Lrs < Formula
  desc "Vertex enumeration/convex hull problems"
  homepage "https://cgm.cs.mcgill.ca/~avis/C/lrs.html"
  url "https://cgm.cs.mcgill.ca/~avis/C/lrslib/archive/lrslib-073.tar.gz"
  sha256 "c49a4ebd856183473d1d5a62785fcdfe1057d5d671d4b96f3a1250eb1afe4e83"
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
