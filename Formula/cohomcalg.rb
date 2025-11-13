class Cohomcalg < Formula
  desc "Computation of sheaf cohomologies for line bundles on toric varieties"
  homepage "https://github.com/BenjaminJurke/cohomCalg"
  url "https://github.com/BenjaminJurke/cohomCalg/archive/refs/tags/v0.32.tar.gz"
  sha256 "367c52b99c0b0a4794b215181439bf54abe4998872d3ef25d793bc13c4d40e42"
  license "GPL-3.0-only"
  revision 1

  bottle do
    root_url "https://ghcr.io/v2/macaulay2/tap"
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c436f6922dcd20a18a6ef10d38595b4266737725ddfe158eebe30f1d920871d1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "df917df886605342a3b62f831dc60c6ebb4257c478fcaa3dd3e327696d1ca694"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ea1f8e946ab3f17dce6c77e56db8df744995e3f4c4ef229ef071c850430c17ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a43ff2306819366ead3ca33d19271fe490acab04f4d72d20a85dc17b2d4a1bde"
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
