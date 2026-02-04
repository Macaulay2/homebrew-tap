class Memtailor < Formula
  desc "C++ library of special purpose memory allocators"
  homepage "https://github.com/Macaulay2/memtailor"
  url "https://github.com/Macaulay2/memtailor/archive/refs/tags/v1.2.tar.gz"
  sha256 "c8a353a349104fb9d984045ff1bb12b5ab108ba5dd4487e88a4166625f61227a"
  license "BSD-3-Clause"

  bottle do
    root_url "https://ghcr.io/v2/macaulay2/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "de32109134cbac1824dc294c436e219df07bcb5dfb3cd70a89fe9775289caeb0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "94ee72f40221e584b1b7b80f56c1e78e349cfa11b8a4f10e40e34a96ebb39586"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fa681c0b63cfd59ac2354833db8a8790fbc28a83505df281d3cc4b475155e762"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "813ba63fa3246911d8db138c006a24fd71670ad42849d06a63af57d8ba572d2b"
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
