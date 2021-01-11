class Memtailor < Formula
  desc "C++ library of special purpose memory allocators"
  homepage "https://github.com/Macaulay2/memtailor"
  url "https://github.com/Macaulay2/memtailor.git", using: :git, branch: "master"
  version "1.0"
  license "BSD-3-Clause"
  revision 8

  bottle do
    root_url "https://github.com/Macaulay2/homebrew-tap/releases/download/memtailor-1.0_8"
    cellar :any_skip_relocation
    sha256 "cb76875ca3ee894780fd0f0c0127f879728519c52e9825bbd08c7ab31796ef51" => :catalina
    sha256 "8782a10b9505818b6c6944b858e3c308b1f0e4874de32d325b17780ed23674ee" => :x86_64_linux
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
