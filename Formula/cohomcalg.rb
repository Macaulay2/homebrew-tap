class Cohomcalg < Formula
  desc "Computation of sheaf cohomologies for line bundles on toric varieties"
  homepage "https://github.com/BenjaminJurke/cohomCalg"
  url "https://github.com/BenjaminJurke/cohomCalg/archive/refs/tags/v0.32.tar.gz"
  sha256 "367c52b99c0b0a4794b215181439bf54abe4998872d3ef25d793bc13c4d40e42"
  license "GPL-3.0-only"
  revision 1

  bottle do
    root_url "https://github.com/Macaulay2/homebrew-tap/releases/download/cohomcalg-0.32_1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e1d322af4524672156037f61dd94f1a31f068bb2cb5a71e9be00d957ec8afe3e"
    sha256 cellar: :any_skip_relocation, big_sur:        "c330c447686cc60c9f2b99588664ea5852cbb7f5efa59f0833ef93bf19845b04"
    sha256 cellar: :any_skip_relocation, catalina:       "9155214e22ea4ab1baba6f30b96f882052d037862fa5ae1b1b996a7abfb46611"
    sha256 cellar: :any_skip_relocation, monterey:       "b2ae1ed1771561d8481476bde3a45ba47bfb9962ab91f22b84cfc2c38fabd058"
    sha256 cellar: :any_skip_relocation, ventura:        "74cbe4b64202917e0fff9e497c5ffb8f7eedd03c1026b22b60005a22a80cd1e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bb70a659a2d7eecd59e5902dbb82c26f9de2e5939d44b362070d67d5d5f3a4f3"
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
