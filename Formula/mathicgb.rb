class Mathicgb < Formula
  desc "Compute (signature) Groebner bases using the fast datastructures from mathic"
  homepage "https://github.com/Macaulay2/mathicgb"
  url "https://github.com/Macaulay2/mathicgb/releases/download/v1.5/mathicgb-1.5.tar.gz"
  sha256 "07fc9683153430d137c239d57120e1dc8a2288e100002440298093dc12984624"
  license "GPL-2.0-or-later"

  bottle do
    root_url "https://ghcr.io/v2/macaulay2/tap"
    sha256 cellar: :any, arm64_golden_gate: "09845c7ad0e9d8e8cb88c51e09d0f4f81fa156864a49115138cb6d293db0825a"
    sha256 cellar: :any, arm64_tahoe:       "c0a294481a5ed848e8c512f355df0c59c6b0bd71d4b7f9c151c67d1db0e159b1"
    sha256 cellar: :any, arm64_sequoia:     "df8f2f8b53c32ecd5e7d8bfb7101daaf5f34e0d5ac36bcaacb5f7635a18e54b9"
    sha256 cellar: :any, arm64_linux:       "6f98337d9d7710aa0c4c74a4a822fcfa882af45384c8815d991df2233ab88fbb"
    sha256 cellar: :any, x86_64_linux:      "f048a6524d9a89fbfbe5f26f47bf24249d6ecfebc054b96f0fafc2ac504f3339"
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
