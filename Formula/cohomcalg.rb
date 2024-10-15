class Cohomcalg < Formula
  desc "Computation of sheaf cohomologies for line bundles on toric varieties"
  homepage "https://github.com/BenjaminJurke/cohomCalg"
  url "https://github.com/BenjaminJurke/cohomCalg/archive/refs/tags/v0.32.tar.gz"
  sha256 "367c52b99c0b0a4794b215181439bf54abe4998872d3ef25d793bc13c4d40e42"
  license "GPL-3.0-only"
  revision 1

  bottle do
    root_url "https://ghcr.io/v2/macaulay2/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0494687d5bc2bf2c3552ed16c9fd9709e49a7475b8271528dc6428555014e585"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d6b7c119bed3c521348f1b828bf317af6e99a2c207b0edeac17ec3048a894712"
    sha256 cellar: :any_skip_relocation, ventura:       "f0789206c6198b4d49aa2ed74f34f6b4f56721c58f9f99db18ec16e644961f1b"
    sha256 cellar: :any_skip_relocation, monterey:      "72b8c0c3b24a56892bb4ac78921bb03b96114584c213e93f9602353917e4055c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4deafd4a90a2d011690e5c097fe3a6deb27736237a33007ad7bbaa09c992bdb8"
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
