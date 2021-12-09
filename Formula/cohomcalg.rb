class Cohomcalg < Formula
  desc "Computation of sheaf cohomologies for line bundles on toric varieties"
  homepage "https://github.com/BenjaminJurke/cohomCalg"
  url "https://github.com/BenjaminJurke/cohomCalg/archive/v0.32.tar.gz"
  sha256 "367c52b99c0b0a4794b215181439bf54abe4998872d3ef25d793bc13c4d40e42"
  license "GPL-3.0-only"
  revision 1

  bottle do
    root_url "https://github.com/Macaulay2/homebrew-tap/releases/download/cohomcalg-0.32"
    sha256 cellar: :any_skip_relocation, catalina:     "e78b6986b83f2b03c6c287aa94a77a374236238292cd81ad20cb1363fe48903d"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "9beeba1639ebbc8201c2aeb18ebca2202b8137502be52b5b6456264be7e2f1bc"
  end

  def install
    ENV.cxx11
    system "make", "prefix=#{prefix}",
           "CXXFLAGS=-std=gnu++11",
           "CC=#{ENV.cc}", "LD=#{ENV.cxx}"
    bin.install "bin/cohomcalg"
  end

  test do
    system "true"
  end
end
