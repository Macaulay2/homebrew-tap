class Memtailor < Formula
  desc "C++ library of special purpose memory allocators"
  homepage "https://github.com/Macaulay2/memtailor"
  url "https://github.com/Macaulay2/memtailor/releases/download/v1.5/memtailor-1.5.tar.gz"
  sha256 "53052f0fa41283a3eb575a529d019ba24dad40e6f347a47b00eb87339c4d8e6a"
  license "BSD-3-Clause"

  bottle do
    root_url "https://ghcr.io/v2/macaulay2/tap"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9baf526d88bb3d8a6f7691c0df76404b26becc6282334c2ed8d43fcdb760f945"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "bdee563c43d849667287fa7e720a7560e85772638aeea297fb933751989d4104"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a77e5d5bf8112769fda6eb604ccc6539f98ff6e0fcf6c170e2dc612dc61c1368"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "fbaa45638ab5227060bd72cb82f46cf165ec84f4516a8265c8baa8fb7977acee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "2b3c1a1574b2e2623a3dce52aac996e8a2cd2c2295cf75774df97fe6bbbc052b"
  end

  unless OS.mac?
    fails_with gcc: "4"
    fails_with gcc: "5"
  end

  depends_on "cmake" => :build

  def install
    ENV.cxx11
    system "cmake", "-S", ".", "-B", ".", "-DBUILD_TESTING=off", *std_cmake_args
    system "make", "install"
  end

  test do
    system "true"
  end
end
