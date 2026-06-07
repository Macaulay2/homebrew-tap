class Memtailor < Formula
  desc "C++ library of special purpose memory allocators"
  homepage "https://github.com/Macaulay2/memtailor"
  url "https://github.com/Macaulay2/memtailor/releases/download/v1.4/memtailor-1.4.tar.gz"
  sha256 "4d5baebf701b04b44201b75831f451305b572a5bc39235a94567ad4e59ad6cdc"
  license "BSD-3-Clause"

  bottle do
    root_url "https://ghcr.io/v2/macaulay2/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "386d2309193ae183e5d68c57226a492cdae5269148a79262ade4cee91fd9d9b5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3be449f5b993fab76de7797d3816d0dc6cc24d43a6992ce7e2be62a9f4dd048b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0028df9e31ea6226f3d5c2d5e6c2919e9c652b6a39bd6bf6b95d2aa8c446a711"
    sha256 cellar: :any_skip_relocation, sequoia:       "3b4f108c9d86a7a021b6a865020fc0127d11b8368887384c41c4977deb425bef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6196bde5e78164e55e6f61dcfad305b31306c6cab290b5fdab39123bc00019e7"
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
