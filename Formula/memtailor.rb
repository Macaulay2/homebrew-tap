class Memtailor < Formula
  desc "C++ library of special purpose memory allocators"
  homepage "https://github.com/Macaulay2/memtailor"
  url "https://github.com/Macaulay2/memtailor.git", using: :git, branch: "master"
  version "1.0"
  license "BSD-3-Clause"
  revision 10

  bottle do
    root_url "https://github.com/Macaulay2/homebrew-tap/releases/download/memtailor-1.0_10"
    sha256 cellar: :any_skip_relocation, arm64_sonoma: "8625ebc5b505c45a6791b9e37135f77e9fb5581c872dc67e428de90a8267ab72"
    sha256 cellar: :any_skip_relocation, ventura:      "f76bd8f10b3e75f57af082550556c1d775db0d3988caa758242749cba3d15edd"
    sha256 cellar: :any_skip_relocation, monterey:     "17d26b8168d0b0e89957fc7980153603a8dcd7f9cdc2db36053321b51da4b00b"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "d6d00ef110f20f2452fdbac2a71ffefa02e221e37ab45ec23d736fd19b3014d4"
  end

  unless OS.mac?
    fails_with gcc: "4"
    fails_with gcc: "5"
  end

  depends_on "cmake" => :build

  def install
    ENV.cxx11
    system "cmake", ".", "-DBUILD_TESTING=off", *std_cmake_args
    system "make", "install"
  end

  test do
    system "true"
  end
end
