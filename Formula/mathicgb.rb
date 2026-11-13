class Mathicgb < Formula
  desc "Compute (signature) Groebner bases using the fast datastructures from mathic"
  homepage "https://github.com/Macaulay2/mathicgb"
  url "https://github.com/Macaulay2/mathicgb/releases/download/v1.6/mathicgb-1.6.tar.gz"
  sha256 "722fd1c13e0643e2e68ac04bfeec07926ed479f8c32652d4992ac5aeef3157cf"
  license "GPL-2.0-or-later"

  bottle do
    root_url "https://ghcr.io/v2/macaulay2/tap"
    sha256 cellar: :any, arm64_golden_gate: "8c0d3b65fba4b272820ebc65034f57f9ecb63a6b3b2dd156dc2788bf358f1522"
    sha256 cellar: :any, arm64_tahoe:       "e5316dbabae235d9eb95b67144743762f02a3141af7c3d5c3956c5d9dc88fce5"
    sha256 cellar: :any, arm64_sequoia:     "cbde7efc077aefd7dac73fbb2f9e049832ed6f2b9149662d4d9bdc8f74e209d7"
    sha256 cellar: :any, arm64_linux:       "1991d71182a686a81527dd710f982e347b5a826c4c8d7b65db8caa73eaa81e0e"
    sha256 cellar: :any, x86_64_linux:      "b0d9012005e5366657cf3805ba455333a7d17a5a3328a1f063820c39404dbdff"
  end

  option "without-mgb", "don't build mgb"

  unless OS.mac?
    fails_with gcc: "4"
    fails_with gcc: "5"
  end

  depends_on "cmake" => :build

  depends_on "mathic"
  depends_on "memtailor"
  depends_on "tbb"

  def install
    ENV.cxx11
    args = std_cmake_args
    args << "-DBUILD_TESTING=off"
    args << "-DCMAKE_PREFIX_PATH=#{Formula["memtailor"].prefix};#{Formula["mathic"].prefix}"
    args << "-Denable_mgb=off" if build.without?("mgb")
    args << "-Dwith_tbb=on" << "-DTBB_ROOT_DIR=#{Formula["tbb"].prefix}" if build.with?("tbb")
    system "cmake", "-S", ".", "-B", "build", *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system "true"
  end
end
