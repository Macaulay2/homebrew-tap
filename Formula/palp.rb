class Palp < Formula
  desc "Vertex enumeration/convex hull problems"
  homepage "https://hep.itp.tuwien.ac.at/~kreuzer/CY/CYpalp.html"
  url "https://hep.itp.tuwien.ac.at/~kreuzer/CY/palp/palp-2.21.tar.gz"
  sha256 "7e4a7bf219998a844c0bcce0a176e49d0743cb4b505a0e195329bf2ec196ddd7"
  license "GPL-3.0-only"

  depends_on "make" => :build if OS.mac?

  def install
    system "gmake", "all-dims", "CC=#{ENV.cc}"
    bin.install Dir["*.x"]
  end

  test do
    system "true"
  end
end
