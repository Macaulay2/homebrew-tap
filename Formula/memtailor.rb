class Memtailor < Formula
  desc "C++ library of special purpose memory allocators"
  homepage "https://github.com/Macaulay2/memtailor"
  url "https://github.com/Macaulay2/memtailor/releases/download/v1.4/memtailor-1.4.tar.gz"
  sha256 "4d5baebf701b04b44201b75831f451305b572a5bc39235a94567ad4e59ad6cdc"
  license "BSD-3-Clause"

  bottle do
    root_url "https://ghcr.io/v2/macaulay2/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0da5080dc5e5df4d52320401f93820f24b2f5fd9da1688c84040f4edc5fd24da"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "187bd97e92aafec2b86ae1c9332eeadee3df3be727a2a2404c6de5f87a883e60"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "999956f40b3b7b47858fa5bc775d266120234c6ccb1cae9960d6f794ba462e2a"
    sha256 cellar: :any_skip_relocation, sequoia:       "e5377891fc927bc9e72607b17d39c4d1fdebac80258918120bda7c97621a34a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d901b5c70a017c78d88c12dd080ffbc25199ec6eb38f627294ba2bf34c636815"
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
