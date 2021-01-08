class Memtailor < Formula
  desc "C++ library of special purpose memory allocators"
  homepage "https://github.com/Macaulay2/memtailor"
  url "https://github.com/Macaulay2/memtailor.git", using: :git, branch: "master"
  version "1.0"
  license "BSD-3-Clause"
  revision 4

  bottle do
    root_url "https://github.com/mahrud/homebrew-tap/releases/download/memtailor-1.0_1"
    cellar :any_skip_relocation
    sha256 "cec7a023232eacafabe9e30aec6e8f6f54780508507f0f69354b0f80542e0fb4" => :catalina
    sha256 "2d602d10712b5def46a711f2d7e9b2024d71ac890e489a76a8c8520e60fa2349" => :x86_64_linux
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
