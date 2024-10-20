class Lrs < Formula
  desc "Vertex enumeration/convex hull problems"
  homepage "https://cgm.cs.mcgill.ca/~avis/C/lrs.html"
  url "https://cgm.cs.mcgill.ca/~avis/C/lrslib/archive/lrslib-073.tar.gz"
  sha256 "c49a4ebd856183473d1d5a62785fcdfe1057d5d671d4b96f3a1250eb1afe4e83"
  license "GPL-2.0-only"

  bottle do
    root_url "https://ghcr.io/v2/macaulay2/tap"
    sha256 cellar: :any,                 arm64_sequoia: "08a587b1a92a7132b24a947836b5546436ded6f5df9489b81861490bfe61eb17"
    sha256 cellar: :any,                 arm64_sonoma:  "daf6ee2d267b9add96374200793527554e6b3b4930e0cbd1bbd1a474ccee2f96"
    sha256 cellar: :any,                 ventura:       "ecb16ef81ed59137491a4cc0410756fc473250afd67c8d2676dcedc385086428"
    sha256 cellar: :any,                 monterey:      "c11d69cd5ff1f78f0aa0b362f4896988286ac991081459def67c7ee0798c78f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a875b3187a4d2a3b3b41895c3159defdcb4e9ed9db3cda197bca9621f0885db3"
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
