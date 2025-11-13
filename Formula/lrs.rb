class Lrs < Formula
  desc "Vertex enumeration/convex hull problems"
  homepage "https://cgm.cs.mcgill.ca/~avis/C/lrs.html"
  url "https://cgm.cs.mcgill.ca/~avis/C/lrslib/archive/lrslib-073.tar.gz"
  sha256 "c49a4ebd856183473d1d5a62785fcdfe1057d5d671d4b96f3a1250eb1afe4e83"
  license "GPL-2.0-only"

  bottle do
    root_url "https://ghcr.io/v2/macaulay2/tap"
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "a7eab80124183b373959b9cc33b8136bc53ad64fa76dc115e5c78a8f7bfc0850"
    sha256 cellar: :any,                 arm64_sequoia: "f8502cc7eb5a043aa6e8f7d5f74492b13711ef22be3746b45cd42480f7e1213d"
    sha256 cellar: :any,                 arm64_sonoma:  "7b53a3c03235584752ed1ddb559cf9210cffa62f9a968d9303aecb7b001c3d3f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c83a56060560a21b2caa3dbe127101e2b96689d40fa83963bbf6061904ce5b22"
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
