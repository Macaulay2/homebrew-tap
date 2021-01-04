class Memtailor < Formula
  desc "C++ library of special purpose memory allocators"
  homepage "https://github.com/Macaulay2/memtailor"
  url "https://github.com/Macaulay2/memtailor.git", using: :git, branch: "master"
  version "1.0"
  license "BSD-3-Clause"

  bottle do
    root_url "https://github.com/mahrud/homebrew-tap/releases/download/memtailor-1.0"
    cellar :any_skip_relocation
    sha256 "971f26f805353d75df74e9ee6b50ac0c02b73947b2e901619b700042be5cb99c" => :catalina
    sha256 "cadca345313bc6a77527c0efbecd4b5533446538fe15e6a7e22511bb3495b471" => :x86_64_linux
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    system "true"
  end
end
