class Palp < Formula
  desc "a Package for Analyzing Lattice Polytopes"
  homepage "https://hep.itp.tuwien.ac.at/~kreuzer/CY/CYpalp.html"
  url "https://hep.itp.tuwien.ac.at/~kreuzer/CY/palp/palp-2.21.tar.gz"
  sha256 "7e4a7bf219998a844c0bcce0a176e49d0743cb4b505a0e195329bf2ec196ddd7"
  license "GPL-3.0-only"

  bottle do
    root_url "https://ghcr.io/v2/macaulay2/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "973703affbfccb31cf3194a6ac5143651d1ccc2308dc0553b51687a69cd66947"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a2b775d198e6fa89d9943cf06a9ba1d0a6e471be4817b0006a268fd2773bc78e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0771e5c3105db65c838e0e13636d533063e1601c510dd9f9c5c9a531cea92eab"
    sha256 cellar: :any_skip_relocation, sequoia:       "530bc0ad74c2b024072652ac0ae4a9511905f5a6f4cbbaf1cc69fce210317a9b"
    sha256 cellar: :any,                 x86_64_linux:  "5749867b7caae155dba2700bd02a83cf1787a48bc439f978f70446a947f29cf8"
  end

  depends_on "make" => :build if OS.mac?

  def install
    system "gmake", "all-dims", "CC=#{ENV.cc}"
    bin.install Dir["*.x"]
  end

  test do
    system "true"
  end
end
