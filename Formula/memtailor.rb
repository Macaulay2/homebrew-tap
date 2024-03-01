class Memtailor < Formula
  desc "C++ library of special purpose memory allocators"
  homepage "https://github.com/Macaulay2/memtailor"
  url "https://github.com/Macaulay2/memtailor.git", using: :git, branch: "master"
  version "1.0"
  license "BSD-3-Clause"
  revision 10

  bottle do
    root_url "https://github.com/Macaulay2/homebrew-tap/releases/download/memtailor-1.0_9"
    sha256 cellar: :any_skip_relocation, catalina:     "b018381c93d5e16f1f6d60993d3cc91c898d79055f53c912059b9fd9611e01c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "e704b05c681e77b63eb2cf80c0980bb3fd86cdd47f28ad5fb2ff32d126d5b4a6"
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
