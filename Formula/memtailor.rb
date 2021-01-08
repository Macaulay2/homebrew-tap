class Memtailor < Formula
  desc "C++ library of special purpose memory allocators"
  homepage "https://github.com/Macaulay2/memtailor"
  url "https://github.com/Macaulay2/memtailor.git", using: :git, branch: "master"
  version "1.0"
  license "BSD-3-Clause"
  revision 4

  bottle do
    root_url "https://github.com/mahrud/homebrew-tap/releases/download/memtailor-1.0_4"
    cellar :any_skip_relocation
    sha256 "ca8ebe4bfe526d54e9dfe3e71379a568b18e4333f52ee521f650d52005fe499c" => :catalina
    sha256 "ec932eca2858c4f066964e4a39be898e84012552382e7e139e668d77836171d7" => :x86_64_linux
  end

  unless OS.mac?
    fails_with gcc: "4"
    fails_with gcc: "5"
    depends_on "gcc@9" => :build
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
