class Memtailor < Formula
  desc "C++ library of special purpose memory allocators"
  homepage "https://github.com/Macaulay2/memtailor"
  url "https://github.com/Macaulay2/memtailor/releases/download/v1.3/memtailor-1.3.tar.gz"
  sha256 "10f0c016e67912be1711a54b18c54d7024c8bfcaf0f279e11187402994150a20"
  license "BSD-3-Clause"

  bottle do
    root_url "https://ghcr.io/v2/macaulay2/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3581d7cecc56714000466fe73cd3ee0ab060c8b0ccba9bfb6a24f6c351c0e62a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0336bb30bf6156056c22bfc7276ebdea0eae1a8ba390c37474dc1f0356109132"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "78f6bb4978644de6a8c33c70440ba3bdef2985e0f7f92f1c4465927268315c1a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b205ddb2fedbb229f85cbc66d45022014356b138fffc89925c748594420bc293"
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
